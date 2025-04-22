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
    case paginate(FetchStrategy)
    case recentSearch
    case search(query: String)
}

let userReducer: (UserState, UserAction) async -> UserState = { state, action in
    let domainManager = ServiceLocator.domainManager
    
    var newState = state
    newState.lastAction = action
    
    switch action {
    case .invalidate:
        newState.viewState = .initial
    case .search(let query):
        newState.viewState = await domainManager.searchUser(query: query)
    case .paginate(let strategy):
        newState.viewState = await domainManager.getUsers(strategy: strategy)
    case .recentSearch:
        let recentSearchedResult = await domainManager.getRecentSearches()
        if case .loaded(let recentSearches) = recentSearchedResult {
            if !recentSearches.isEmpty {
                newState.viewState = .loaded(oldData: recentSearches)
            } else {
                newState.lastAction = nil
            }
        } else if case .failure(let message) = recentSearchedResult {
            newState.viewState = .failure(message: message)
        }
    }
    return newState
}

typealias UserStore = AppStore<UserState, UserAction>
