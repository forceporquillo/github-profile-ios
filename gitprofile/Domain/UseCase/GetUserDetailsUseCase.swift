//
//  GetUserDetailsUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/3/24.
//

import Foundation

class GetUserDetailsUseCase {
    
    private let dataManager: UserDataManager
    private let userMapper: UserDetailsMapper
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
        self.userMapper = UserDetailsMapper()
    }

    func execute(username: String) async -> GenericViewState<UserDetailsUiModel> {
        return await dataManager.findUserDetails(username: username)
            .fold(onSuccess: { details in
                .success(repos: userMapper.map(from: details))
            }, onFailure: { error in
                .failure(message: error.localizedDescription)
            })
    }
    
    private class UserDetailsMapper : EntityMapper {
        typealias From = UserDetailsResponse
        typealias To = UserDetailsUiModel
        
        func map(from entity: UserDetailsResponse) -> UserDetailsUiModel {
            return UserDetailsUiModel(
                name: entity.name ?? "",
                avatarUrl: entity.avatarUrl ?? "",
                bio: entity.bio?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                company: entity.company,
                location: entity.location,
                htmlUrl: entity.htmlUrl?.replacingOccurrences(of: "https://", with: ""),
                twitterHandle: entity.twitterUsername,
                followers: entity.followers ?? 0,
                following: entity.following ?? 0
            )
        }
    }
}

struct UserDetailsUiModel: Equatable {
    var name: String
    var avatarUrl: String
    var bio: String
    var company: String?
    var location: String?
    var htmlUrl: String?
    var email: String?
    var twitterHandle: String?
    var followers: Int
    var following: Int
}

