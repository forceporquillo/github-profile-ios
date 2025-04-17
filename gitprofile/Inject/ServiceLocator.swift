//
//  ServiceLocator.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

/// Provides access to shared service instances.
class ServiceLocator {
    /// Lazily loads and provides the user data manager.
    static let dataManager: UserDataManager = {
        let factory = UserDataComponentFactory()
        return UserNetworkDataManager(factory)
    }()

    /// Lazily loads and provides the user domain manager.
    static let domainManager: UserDomainManager = {
        let factory = UserDomainComponentFactory()
        return UserUseCaseManager(factory)
    }()
}
