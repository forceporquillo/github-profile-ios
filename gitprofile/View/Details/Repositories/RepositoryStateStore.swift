//
//  RepositoryStateStore.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

let userRepoReducer: (UserReposState, GenericFetchAction) async -> UserReposState = { state, action in
    await genericReducer(state: state, action: action) { domainManager, username in
        await domainManager.getUserRepos(username: username)
    }
}

typealias UserReposState = UserDetailsGenericState<UserReposUiModel>
typealias UserRepoStore = AppStore<UserReposState, GenericFetchAction>
