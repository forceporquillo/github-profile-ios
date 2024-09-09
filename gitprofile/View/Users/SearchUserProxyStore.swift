//
//  SearchUserProxyStore.swift
//  GitHub Profile
//
//  Created by Aljan Porquillo on 9/9/24.
//

import Combine
import Observation
import SwiftUI

class SearchUserProxyStore: ObservableObject {
    
    private let userStore: UserStore
    
    private var searchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(userStore: UserStore) {
        self.userStore = userStore
        self.startObserver()
    }
    
    private func startObserver() {
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.userStore.send(.search(query: searchText))
            }
            .store(in: &cancellables)
    }

    func dispatch(query: String) {
        userStore.send(.invalidate)
        searchSubject.send(query)
    }
}
