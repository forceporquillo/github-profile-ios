//
//  UserDetailsRepository.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/3/24.
//

import Foundation

protocol UserDetailsRepository {
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
    
}
