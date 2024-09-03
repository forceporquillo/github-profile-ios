//
//  UserNetworkDataManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

protocol UserDataManager {
    
    func usersNetworkCall() async -> Result<[UserResponse], Error>
    func userReposNetworkCall(username: String) async -> Result<[RepositoriesResponse], Error>
    func userDetailsNetworkCall(username: String) async -> Result<UserDetailsResponse, Error>
}

class UserNetworkDataManager : UserDataManager {
   
    private let pageSize = "20"
    private let component: UserDataComponent
    
    init(_ component: UserDataComponent) {
        self.component = component
    }

    func usersNetworkCall() async -> Result<[UserResponse], Error> {
        let userRepo = component.providesUsersRepository()
        let queryParams = [
            URLQueryItem(name: "since", value: "\(userRepo.getNextPage())"),
            URLQueryItem(name: "per_page", value: pageSize)
        ]
        return await withCheckedContinuation { continuation in
            component.providesGetUsersNetworkCall().execute(params: queryParams, completion: {
                (result: (Result<GetUsersResponse, Error>)) in
                let data: Result<[UserResponse], Error> = result.fold(onSuccess: { response in
                    let (newUsers, next) = (response.data, response.next)
                    if let nextPage = next {
                        userRepo.saveNextPage(since: Int(nextPage) ?? 0)
                    }
                    userRepo.saveUsers(users: newUsers)
                    return .success(userRepo.getUsers())
                }, onFailure: { error in .failure(error) })
                continuation.resume(returning: data)
            })
        }
    }
    
    func userReposNetworkCall(username: String) async -> Result<[RepositoriesResponse], Error> {
        let starredRepo = component.providesStarredReposRepository()
        let queryParams = [
            URLQueryItem(name: "page", value: "\(starredRepo.getNextPage(username: username))"),
            URLQueryItem(name: "per_page", value: pageSize)
        ]
        return await withCheckedContinuation { continuation in
            component.providesGetRepositoriesNetworkCall().execute(username: username, params: queryParams, completion: {
                (result: (Result<GetRepositoriesResponse, Error>)) in
                let mappedResult: Result<[RepositoriesResponse], Error> = result.map { response in
                    let (repositories, next) = (response.data, response.next)
                    starredRepo.saveStarredRepos(username: username, repos: repositories)
                    starredRepo.saveNextPage(username: username, page: next)
                    return starredRepo.getStarredRepos(username: username)
                }
                continuation.resume(returning: mappedResult)
            })
        }
    }

    func userDetailsNetworkCall(username: String) async -> Result<UserDetailsResponse, Error> {
        let userDetailsRepo = component.providesUserDetailsRepository()
        return await withCheckedContinuation { continuation in
            if let userDetails = userDetailsRepo.getUserDetails(username: username) {
                print("Cache")
                DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 1) {
                    print("Calling...")
                    continuation.resume(returning: .success(userDetails))
                }
            } else {
                print("Remote")
                component.providesGetUserDetailsNetworkCall().execute(username: username, completion: { result in
                    let result = result.map { userDetails in
                        userDetailsRepo.saveUserDetails(userDetails: userDetails)
                        return userDetails
                    }
                    continuation.resume(returning: result)
                })
            }
        }
    }
}
