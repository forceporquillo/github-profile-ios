//
//  UsersViewModel.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import Foundation

@MainActor
class UsersViewModel : ObservableObject {
    
    @Published var viewState = UsersViewState<[UserUiModel]>.initial
    @Published var showFooter = false

    private let domainManager = ServiceLocator.domainManager

    func fetchUsers() async {
        let newState = await domainManager.getUsers()
        DispatchQueue.main.async {
            self.viewState = newState
        }
    }

    func onLoadMore() {
        print("onLoadMore...")
        self.showFooter = true
        Task {
            await fetchUsers()
            self.showFooter = false
        }
    }
}
