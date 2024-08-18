//
//  UserDetailsGenericStateStore.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

import Foundation

struct UserDetailsGenericState<T: Equatable>: Equatable {
    var viewState: LoadableViewState<[T]> = .initial
}

enum GenericFetchAction: Equatable {
    case loadPage(username: String)
}

func genericReducer<T: Equatable>(
    state: UserDetailsGenericState<T>,
    action: GenericFetchAction,
    fetchFunction: @escaping (UserDomainManager, String) async -> LoadableViewState<[T]>
) async -> UserDetailsGenericState<T> {
    var newState = state
    
    switch action {
    case .loadPage(let username):
        newState.viewState = await fetchFunction(ServiceLocator.domainManager, username)
        return newState
    }
}

typealias GenericStore<T: Equatable> = AppStore<UserDetailsGenericState<T>, GenericFetchAction>
