//
//  UserDetailsRepository.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/3/24.
//

import Foundation

protocol UserDetailsRepository {
    func getAllUserDetails(username: String) -> [UserDetailsResponse]
    func getUserDetails(username: String) -> UserDetailsResponse?
    func saveUserDetails(userDetails: UserDetailsResponse)
}

class UserDetailsRepositoryImpl : UserDetailsRepository {
    
    private let cacheManager = CacheManager.shared
    private let cacheKeyPrefix = "userDetails_" // Prefix to avoid key collisions
    private let prefixListKey = "userDetailsPrefixes" // Key for storing prefixes
    
    // MARK: - Helper Functions
    
    private func cacheKey(for username: String) -> String {
        return "\(cacheKeyPrefix)\(username)"
    }
    
    private func getPrefixes() -> [String] {
        return cacheManager.retrieve(forKey: prefixListKey) ?? []
    }
    
    private func savePrefix(prefix: String) {
        var prefixes = getPrefixes()
        if !prefixes.contains(prefix) {
            prefixes.append(prefix)
            cacheManager.store(object: prefixes, forKey: prefixListKey)
        }
    }
    
    // MARK: - UserDetailsRepository Conformance
    
    func getUserDetails(username: String) -> UserDetailsResponse? {
        let key = cacheKey(for: username)
        return cacheManager.retrieve(forKey: key)
    }
    
    func saveUserDetails(userDetails: UserDetailsResponse) {
        guard let login = userDetails.login else {
            return
        }
        let key = cacheKey(for: login)
        cacheManager.store(object: userDetails, forKey: key)
        savePrefix(prefix: login)
        
        if let name = userDetails.name {
            savePrefix(prefix: name)
        }
    }
    
    func getAllUserDetails(username: String) -> [UserDetailsResponse] {
        if username.isEmpty {
            return []
        }
        
        var matchingUsers: [UserDetailsResponse] = []
        let prefixes = getPrefixes()
        
        for prefix in prefixes {
            if prefix.starts(with: username){
                let key = cacheKey(for: prefix)
                if let userDetails: UserDetailsResponse = cacheManager.retrieve(forKey: key){
                    matchingUsers.append(userDetails)
                }
            }
        }
        return matchingUsers
    }
    
}
