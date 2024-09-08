//
//  UserNetworkDataManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

protocol UserDataManager {
    
    func loadUsers() async -> Result<[UserResponse], Error>
    func findUserDetails(username: String) async -> Result<UserDetailsResponse, Error>
    func findUserRepos(username: String) async -> Result<PagingSourceEntity<[RepositoriesResponse]>, Error>
    func findUserStarredRepos(username: String) async -> Result<PagingSourceEntity<[StarredRepoResponse]>, Error>
    func findUserOrgs(username: String) async -> Result<PagingSourceEntity<[UserOrgsResponse]>, Error>
}

class UserNetworkDataManager : UserDataManager {
    
    private let logger = LoggerFactory.create(clazz: UserNetworkDataManager.self)
    
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
 
    func findUserStarredRepos(username: String) async -> Result<PagingSourceEntity<[StarredRepoResponse]>, Error> {
        return await executePagingInternal(type: StarredRepoResponse.self, username: username, networkCall: { [self] handler, nextPage in
            let queryParams = [
                URLQueryItem(name: "page", value: "\(nextPage)"),
                URLQueryItem(name: "per_page", value: pageSize)
            ]
            logger.log(message: "ApiCall: GetStarredRepositories for user: \(username), params: \(queryParams)")
            component.providesGetStarredReposNetworkCall().execute(username: username, params: queryParams, completion: handler)
        })
    }
    
    func findUserOrgs(username: String) async -> Result<PagingSourceEntity<[UserOrgsResponse]>, Error> {
        return await executePagingInternal(type: UserOrgsResponse.self, username: username, networkCall: { [self] handler, _ in
            logger.log(message: "ApiCall: GetUserOrganizations for user: \(username)")
            component.providesGetUserOrgsNetworkCall().execute(username: username, completion: handler)
        })
    }
    
    func findUserRepos(username: String) async -> Result<PagingSourceEntity<[RepositoriesResponse]>, Error> {
        return await executePagingInternal(type: RepositoriesResponse.self, username: username, networkCall: { [self] handler, nextPage in
            let queryParams = [
                URLQueryItem(name: "page", value: "\(nextPage)"),
                URLQueryItem(name: "per_page", value: pageSize),
                URLQueryItem(name: "sort", value: "updated")
            ]
            logger.log(message: "ApiCall: GetRepositories for user: \(username), params: \(queryParams)")
            component.providesGetRepositoriesNetworkCall().execute(username: username, params: queryParams, completion: handler)
        }, map: { repos in
            repos.sorted(by: {
                guard let updatedAtA = $0.updatedAt else { return false }
                guard let updateAtB = $1.updatedAt else { return false }
                return updatedAtA > updateAtB
            })
        })
    }
    
    private func executePagingInternal<T: Hashable>(
        type: T.Type, 
        username: String,
        networkCall: @escaping (@escaping PagingCompletionHandler<T>, Int) -> Void,
        map mappingFunc: @escaping ([T]) -> [T] = { data in data }
    ) async -> Result<PagingSourceEntity<[T]>, Error> {
        
        let repository = PagingRepositoryFactory.create(for: type)
        
        return await withCheckedContinuation { continuation in
            let isEndOfPaginationReached = repository.getIsEndOfPagination(username: username)
            if isEndOfPaginationReached == true || repository.getNextPage(username: username) == endOfPaginationReached {
                logger.log(message: "Loading paginated data from cache for user: \(username)")
                let cacheRepos = mappingFunc(repository.getData(username: username))
                return continuation.resume(returning: .success(PagingSourceEntity(data: cacheRepos, endOfPagination: true)))
            }
        
            logger.log(message: "Fetching new data from remote for user: \(username)")
            
            let handler: PagingCompletionHandler<T> = { [self] result in
                let mappedResult = result.map { response in
                    let (data, next, paginationEnded) = (response.data, response.next, response.endOfPaginationReached)
                    logger.log(message: "\(type): End of pagination reached for user \(username) result: \(paginationEnded)")
                    repository.saveData(username, data, next, paginationEnded)
                    return PagingSourceEntity(data: mappingFunc(repository.getData(username: username)))
                }
                continuation.resume(returning: mappedResult)
            }
            
            let nextPage = repository.getNextPage(username: username)
            networkCall(handler, nextPage)
        }
    }
}

typealias PagingCompletionHandler<T> = CompletionHandler<PagingData<[T]>>

struct PagingSourceEntity<T> {
    var data: T
    var endOfPagination: Bool = false
}
