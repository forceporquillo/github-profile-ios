//
//  UserDomainManager.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

protocol UserDomainManager {
    func getUsers() async -> LoadableViewState<[UserUiModel]>
    func getUserRepos(username: String) async -> LoadableViewState<[UserReposUiModel]>
    func getUserDetails(username: String) async -> GenericViewState<UserDetailsUiModel>
    func getStarredRepos(username: String) async -> LoadableViewState<[UserStarredReposUiModel]>
    func getUserOrgs(username: String) async -> LoadableViewState<[UserOrgsUiModel]>
    func searchUser(query: String) async -> LoadableViewState<[UserUiModel]>
}
