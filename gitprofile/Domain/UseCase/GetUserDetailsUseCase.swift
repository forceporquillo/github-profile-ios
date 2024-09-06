//
//  GetUserDetailsUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/3/24.
//

import Foundation

class GetUserDetailsUseCase {
    
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }

    func execute(username: String) async -> UsersViewState<UserDetailsResponse> {
        return await dataManager.findUserDetails(username: username)
            .fold(onSuccess: { details in
                .success(repos: details)
            }, onFailure: { error in
                .failure(message: error.localizedDescription)
            })
    }
}
