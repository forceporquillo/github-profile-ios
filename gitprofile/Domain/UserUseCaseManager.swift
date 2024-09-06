//
//  UserUseCaseManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

class UserUseCaseManager : UserDomainManager {
    
    private let component: UserDomainComponent
    
    init(_ factory: UserDomainComponentFactory) {
        self.component = factory.create()
    }

    func getUsers() async -> UsersViewState<[UserUiModel]> {
        return await component.providesGetUsersUseCase()
            .execute()
    }

    func getUserRepos(username: String) async -> LoadableViewState<[UserReposUiModel]> {
        return await component.providesGetUserRepoUseCase()
            .execute(username: username)
    }
    
    func getUserDetails(username: String) async -> UsersViewState<UserDetailsResponse> {
        return await component.providesGetUserDetailsUseCase()
            .execute(username: username)
    }
    
    func getStarredRepos(username: String) async -> LoadableViewState<[UserStarredReposUiModel]> {
        return await component.providesGetStarredReposUseCase()
            .execute(username: username)
    }
    
    func getUserOrgs(username: String) async -> LoadableViewState<[UserOrgsUiModel]> {
        return await component.providesGetUserOrgsUseCase()
            .execute(username: username)
    }
}
