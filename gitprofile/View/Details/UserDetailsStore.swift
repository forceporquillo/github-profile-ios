//
//  UserDetailsStore.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/8/24.
//

import Foundation

struct UserDetailsState: Equatable {
    static func == (lhs: UserDetailsState, rhs: UserDetailsState) -> Bool {
        return lhs.viewState == rhs.viewState
    }
    
    var viewState: GenericViewState<UserDetailsUiModel> = .initial
}

enum UserDetailsAction: Equatable {
    case fetch(username: String)
}

let detailsReducer: (UserDetailsState, UserDetailsAction) async -> UserDetailsState = { state, action in
    let domainManager = ServiceLocator.domainManager
    
    var newState = state
    switch action {
    case .fetch(let username):
        newState.viewState = await domainManager.getUserDetails(username: username)
        return newState
    }
}

typealias UserDetailsStore = AppStore<UserDetailsState, UserDetailsAction>
