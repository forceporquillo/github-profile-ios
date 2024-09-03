//
//  UserDomainManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

protocol UserDomainManager {
    func usersNetworkCall() async -> UsersViewState<[UserUiModel]>
    func userReposNetworkCall(username: String) async -> [UserReposUiModel]
    func userDetailsNetworkCall(username: String) async -> UsersViewState<UserDetailsResponse>
}
