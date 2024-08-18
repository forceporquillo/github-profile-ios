//
//  UserState.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

struct UserState: Equatable {
    
    var viewState: LoadableViewState<[UserUiModel]> = .initial
}

enum UserAction: Equatable {
    case invalidate
    case paginate
    case search(query: String)
}

let userReducer: (UserState, UserAction) async -> UserState = { state, action in
    var newState = state
    switch action {
    case .invalidate:
        newState.viewState = .initial
    case .search(let query):
        newState.viewState = await ServiceLocator.domainManager.searchUser(query: query)
    case .paginate:
        newState.viewState = await ServiceLocator.domainManager.getUsers()
    }
    return newState
}

typealias UserStore = AppStore<UserState, UserAction>
