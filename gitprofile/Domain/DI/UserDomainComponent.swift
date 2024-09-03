//
//  UserComponent.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

// MARK: - Manual Dependency Injection to Domain Module
protocol UserDomainComponent {
    func providesGetUsersUseCase() -> GetUsersUseCase
    func providesGetUserRepoUseCase() -> GetUserReposUseCase
    func providesGetUserDetailsUseCase() -> GetUserDetailsUseCase
}

private class UserComponentImpl : UserDomainComponent {

    static let shared = UserComponentImpl()

    // MARK: - Singleton component
    private static let getUserUseCase = GetUsersUseCase(ServiceLocator.dataManager)
    private static let getUserRepoUseCase = GetUserReposUseCase(ServiceLocator.dataManager)
    private static let getUserDetailsUseCase = GetUserDetailsUseCase(ServiceLocator.dataManager)

    func providesGetUsersUseCase() -> GetUsersUseCase {
        return UserComponentImpl.getUserUseCase
    }

    func providesGetUserRepoUseCase() -> GetUserReposUseCase {
        return UserComponentImpl.getUserRepoUseCase
    }
    
    func providesGetUserDetailsUseCase() -> GetUserDetailsUseCase {
        return UserComponentImpl.getUserDetailsUseCase
    }
}

class UserDomainComponentFactory {
    
    static func create() -> UserDomainComponent {
        return UserComponentImpl.shared
    }
    
}
