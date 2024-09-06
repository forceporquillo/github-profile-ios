//
//  UserDetailsViewModel.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/31/24.
//

import Foundation

@MainActor
class UserDetailsViewModel : ObservableObject {
   
    @Published private (set) var details: UsersViewState<UserDetailsResponse> = UsersViewState.initial
    
    @Published private (set) var repositories: LoadableViewState<[UserReposUiModel]> = LoadableViewState.initial
    @Published private (set) var organizations: LoadableViewState<[UserOrgsUiModel]> = LoadableViewState.initial
    @Published private (set) var starredRepos: LoadableViewState<[UserStarredReposUiModel]> = LoadableViewState.initial

    private let domainManager = ServiceLocator.domainManager

    private var username = ""

    var task: Task<Void, Error>?
    
    func fetchDetails(username: String) async {
        self.details = UsersViewState.initial
        self.username = username

        self.details = await domainManager.getUserDetails(username: username)
        
        if case .success(_) = details {
            let repos = await domainManager.getUserRepos(username: username)
            let orgs = await domainManager.getUserOrgs(username: username)
            let starred = await domainManager.getStarredRepos(username: username)
            
            print("Fetching repos")
            self.repositories = repos
            self.organizations = orgs
            self.starredRepos = starred
        }
    }

    func onLoadMore() {
        print("Request more")
        if case let LoadableViewState.success(data) = self.repositories {
            self.repositories = LoadableViewState.loaded(oldRepos: data)
        }

        task = Task {
            let repos = await domainManager.getUserRepos(username: self.username)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.repositories = repos
            }
        }
    }
}
