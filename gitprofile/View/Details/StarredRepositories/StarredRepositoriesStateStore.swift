//
//  StarredRepositoriesStateStore.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

let userStarredReducer: (UserStarredRepoState, GenericFetchAction) async -> UserStarredRepoState = { state, action in
    await genericReducer(state: state, action: action) { domainManager, username in
        await domainManager.getStarredRepos(username: username)
    }
}

typealias UserStarredRepoState = UserDetailsGenericState<UserStarredReposUiModel>
typealias UserStarredStore = AppStore<UserStarredRepoState, GenericFetchAction>
