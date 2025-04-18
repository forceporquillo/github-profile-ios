//
//  UserState.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

struct UserState: Equatable {
    var viewState: LoadableViewState<[UserUiModel]> = .initial
    var lastAction: UserAction?
}

enum UserAction: Equatable {
    case invalidate
    case paginate
    case recentSearch
    case search(query: String)
}

let userReducer: (UserState, UserAction) async -> UserState = { state, action in
    var newState = state
    newState.lastAction = action
    switch action {
    case .invalidate:
        newState.viewState = .initial
    case .search(let query):
        newState.viewState = await ServiceLocator.domainManager.searchUser(query: query)
    case .paginate:
        newState.viewState = await ServiceLocator.domainManager.getUsers()
    case .recentSearch:
        let recentSearchesResult = await ServiceLocator.domainManager.getRecentSearches()
        if case .loaded(let recentSearches) = recentSearchesResult {
            if !recentSearches.isEmpty {
                newState.viewState = .loaded(oldData: recentSearches)
            } else {
                newState.lastAction = nil
            }
        } else if case .failure(let message) = recentSearchesResult {
            newState.viewState = .failure(message: message)
        }
    }
    return newState
}

typealias UserStore = AppStore<UserState, UserAction>
