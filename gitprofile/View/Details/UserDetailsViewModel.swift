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
          //  let repos = await domainManager.getUserRepos(username: username)
          //  let orgs = await domainManager.getUserOrgs(username: username)
         //   let starred = await domainManager.getStarredRepos(username: username)
           // self.repositories = repos
           // self.organizations = orgs
           // self.starredRepos = starred
        }
    }
    
    func loadSubDetails(page: DetailPage) {
        task?.cancel()
        task = Task {
            switch page {
            case .repositories:
                self.repositories = await domainManager.getUserRepos(username: username)
            case .organizations:
                self.organizations = await domainManager.getUserOrgs(username: username)
            case .starred:
                self.starredRepos = await domainManager.getStarredRepos(username: username)
            }
        }
    }
}

enum DetailPage {
    case repositories
    case organizations
    case starred
}
