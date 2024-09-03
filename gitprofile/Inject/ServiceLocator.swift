//
//  ServiceLocator.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

class ServiceLocator {
    
    static let dataManager: UserDataManager = {
        UserNetworkDataManager(UserDataComponentFactory.create())
    }()
    
    static let domainManager: UserDomainManager = {
       return UserUseCaseManager(UserDomainComponentFactory.create())
    }()
}
