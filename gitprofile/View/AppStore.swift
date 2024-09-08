//
//  AppStore.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/8/24.
//

import Foundation

@Observable final class AppStore<State, Action> {
    
    private(set) var state: State
    private let reduce: (State, Action) async -> State
    
    private var task: Task<Void, Error>?
    
    init(
        initialState state: State,
        reduce: @escaping (State, Action) async -> State
    ) {
        self.state = state
        self.reduce = reduce
    }
    
    func send(_ action: Action) {
        task?.cancel()
        task = Task {
            let newState = await reduce(state, action)
            DispatchQueue.main.async {
                self.state = newState
            }
        }
    }
}
