//
//  UserNetworkDataManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

protocol UserDataManager {
    
    func loadUsers() async -> Result<[UserResponse], Error>
    func findUserRepos(username: String) async -> Result<[RepositoriesResponse], Error>
    func findUserDetails(username: String) async -> Result<UserDetailsResponse, Error>
    func findUserStarredRepos(username: String) async -> Result<[StarredRepoResponse], Error>
    func findUserOrgs(username: String) async -> Result<[UserOrgsResponse], Error>
}

class UserNetworkDataManager : UserDataManager {

    private let endOfPaginationReached = -1
    private let pageSize = "20"
    
    private let component: UserDataComponent

    init(_ factory: UserDataComponentFactory) {
        self.component = factory.create()
    }

    func loadUsers() async -> Result<[UserResponse], Error> {
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
    
    func findUserRepos(username: String) async -> Result<[RepositoriesResponse], Error> {
        let starredRepo = component.providesStarredReposRepository()
        let nextPage = starredRepo.getNextPage(username: username)
        
        return await withCheckedContinuation { continuation in
            if nextPage == endOfPaginationReached {
                let cacheRepos = starredRepo.getStarredRepos(username: username)
                // TODO: RepositoryEntity(repos: cacheRepos, endOfPaginaiton: true)
                //continuation.resume(returning: .success(RepositoryEntity(repos: starredRepo.getStarredRepos(username: username))))
            }
            let queryParams = [
                URLQueryItem(name: "page", value: "\(nextPage)"),
                URLQueryItem(name: "per_page", value: pageSize)
            ]
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
    
    func findUserStarredRepos(username: String) async -> Result<[StarredRepoResponse], Error> {
//        let starredRepo = component.providesStarredReposRepository()
//        let nextPage = starredRepo.getNextPage(username: username)
        
        return await withCheckedContinuation { continuation in
//            if nextPage == endOfPaginationReached {
//                let cacheRepos = starredRepo.getStarredRepos(username: username)
//                // TODO: RepositoryEntity(repos: cacheRepos, endOfPaginaiton: true)
//                //continuation.resume(returning: .success(RepositoryEntity(repos: starredRepo.getStarredRepos(username: username))))
//            }
            let queryParams = [
                URLQueryItem(name: "page", value: "\(1)"),
                URLQueryItem(name: "per_page", value: pageSize)
            ]
            component.providesGetStarredReposNetworkCall().execute(username: username, params: queryParams, completion: {
                (result: (Result<GetStarredReposResponse, Error>)) in
                let mappedResult: Result<[StarredRepoResponse], Error> = result.map { response in
                    let (starredRepos, next) = (response.starred, response.next)
//                    starredRepo.saveStarredRepos(username: username, repos: repositories)
//                    starredRepo.saveNextPage(username: username, page: next)
                    return /*starredRepo.getStarredRepos(username: username)*/ starredRepos
                }
                continuation.resume(returning: mappedResult)
            })
        }
    }

    func findUserOrgs(username: String) async -> Result<[UserOrgsResponse], Error> {
        let starredRepo = component.providesStarredReposRepository()
      //        let nextPage = starredRepo.getNextPage(username: username)
              
              return await withCheckedContinuation { continuation in
      //            if nextPage == endOfPaginationReached {
      //                let cacheRepos = starredRepo.getStarredRepos(username: username)
      //                // TODO: RepositoryEntity(repos: cacheRepos, endOfPaginaiton: true)
      //                //continuation.resume(returning: .success(RepositoryEntity(repos: starredRepo.getStarredRepos(username: username))))
      //            }
                  let queryParams = [
                      URLQueryItem(name: "page", value: "\(1)"),
                      URLQueryItem(name: "per_page", value: pageSize)
                  ]
                  component.providesGetUserOrgsNetworkCall().execute(username: username, completion: { result in
                      let mappedResult: Result<[UserOrgsResponse], Error> = result.map { response in
                          let (orgs, next) = (response.data, response.next)
      //                    starredRepo.saveStarredRepos(username: username, repos: repositories)
      //                    starredRepo.saveNextPage(username: username, page: next)
                          return /*starredRepo.getStarredRepos(username: username)*/ orgs
                      }
                      continuation.resume(returning: mappedResult)
                  })
              }
    }
    
    func findUserDetails(username: String) async -> Result<UserDetailsResponse, Error> {
        let userDetailsRepo = component.providesUserDetailsRepository()
        return await withCheckedContinuation { continuation in
            if let userDetails = userDetailsRepo.getUserDetails(username: username) {
                continuation.resume(returning: .success(userDetails))
            } else {
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

struct RepositoryEntity {
    var repos: [RepositoriesResponse]
    var endOfPaginaiton: Bool = false
}
