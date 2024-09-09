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
    
    private var userDetailsCache: [String: UserDetailsResponse] = [:]

    func getUserDetails(username: String) -> UserDetailsResponse? {
        return self.userDetailsCache[username]
    }

    func saveUserDetails(userDetails: UserDetailsResponse) {
        guard let username = userDetails.login else {
            return
        }
        self.userDetailsCache[username] = userDetails
    }
    
    func getAllUserDetails(username: String) -> [UserDetailsResponse] {
        return self.userDetailsCache.values
            .filter { details in
                guard let login = details.login else {
                    return false
                }
                guard let name = details.name else {
                   return false
                }
                
                return login.starts(with: username) || name.starts(with: username)
            }
    }
    
}
