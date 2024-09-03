//
//  UserUseCaseManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

class UserUseCaseManager : UserDomainManager {
    
    private let component: UserDomainComponent
    
    init(_ component: UserDomainComponent) {
        self.component = component
    }

    func usersNetworkCall() async -> UsersViewState<[UserUiModel]> {
        return await component.providesGetUsersUseCase()
            .execute()
    }

    func userReposNetworkCall(username: String) async -> [UserReposUiModel] {
        return await component.providesGetUserRepoUseCase()
            .execute(username: username)
    }
    
    func userDetailsNetworkCall(username: String) async -> UsersViewState<UserDetailsResponse> {
        return await component.providesGetUserDetailsUseCase()
            .execute(username: username)
    }
    
}
