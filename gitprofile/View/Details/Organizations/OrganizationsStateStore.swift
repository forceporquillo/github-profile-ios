//
//  OrganizationsStateStore.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

let userOrgReducer: (UserOrgState, GenericFetchAction) async -> UserOrgState = { state, action in
    await genericReducer(state: state, action: action) { domainManager, username in
        await domainManager.getUserOrgs(username: username)
    }
}

typealias UserOrgState = UserDetailsGenericState<UserOrgsUiModel>
typealias UserOrgsStore = AppStore<UserOrgState, GenericFetchAction>
