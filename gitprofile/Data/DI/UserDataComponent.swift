//
//  UserComponent.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

protocol UserDataComponent {
    func providesGetUsersNetworkCall() -> GetAllUsersNetworkCall
    func providesUsersRepository() -> UsersRepository
    
    func providesGetRepositoriesNetworkCall() -> GetUserReposNetworkCall
    func providesStarredReposRepository() -> StarredReposRepository
    
    func providesGetUserDetailsNetworkCall() -> GetUserDetailsNetworkCall
    func providesUserDetailsRepository() -> UserDetailsRepository
}

private class UserComponentImpl : UserDataComponent {
    
    static let shared = UserComponentImpl()

    // MARK: - Remote
    private static let providesGetUsersNetworkCall = GetAllUsersNetworkCall(NetworkComponent.shared)
    private static let providesGetRepositoriesNetworkCall = GetUserReposNetworkCall(NetworkComponent.shared)
    private static let providesGetUserDetailsNetworkCall = GetUserDetailsNetworkCall(NetworkComponent.shared)

    // MARK: - Repositories
    private static let userRepository = UserRepositoryImpl()
    private static let starredRepository = StarredReposRepositoryImpl()
    private static let userDetailsRepository = UserDetailsRepositoryImpl()
    
    func providesGetUsersNetworkCall() -> GetAllUsersNetworkCall {
        return UserComponentImpl.providesGetUsersNetworkCall
    }

    func providesGetRepositoriesNetworkCall() -> GetUserReposNetworkCall {
        return UserComponentImpl.providesGetRepositoriesNetworkCall
    }

    func providesUsersRepository() -> UsersRepository {
        return UserComponentImpl.userRepository
    }
    
    func providesStarredReposRepository() -> StarredReposRepository {
        return UserComponentImpl.starredRepository
    }
    
    func providesGetUserDetailsNetworkCall() -> GetUserDetailsNetworkCall {
        return UserComponentImpl.providesGetUserDetailsNetworkCall
    }
    
    func providesUserDetailsRepository() -> UserDetailsRepository {
        return UserComponentImpl.userDetailsRepository
    }
}

class UserDataComponentFactory {

    static func create() -> UserDataComponent {
        return UserComponentImpl.shared
    }

}
