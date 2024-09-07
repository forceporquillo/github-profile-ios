//
//  UsersViewModel.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import Foundation

@MainActor
class UsersViewModel : ObservableObject {
    
    @Published var viewState = LoadableViewState<[UserUiModel]>.initial

    private let domainManager = ServiceLocator.domainManager

    func fetchUsers(_ resetState: Bool = false) async {
        if resetState {
            self.viewState = LoadableViewState.initial
        }
        let newState = await domainManager.getUsers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewState = newState
        }
    }

    func searchUser(query: String) async {
        self.viewState = LoadableViewState.initial
        self.viewState = await domainManager.searchUser(query: query)
    }
}
