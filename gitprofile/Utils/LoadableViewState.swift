//
//  LoadableViewState.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

import Foundation

enum LoadableViewState<T : Equatable> {
    case initial
    case loaded(oldData: T)
    case success(data: T)
    case failure(message: String)
    case endOfPaginatedReached(lastData: T)
}

extension LoadableViewState: Equatable {
    static func == (lhs: LoadableViewState<T>, rhs: LoadableViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loaded(let oldData1), .loaded(let oldData2)):
            return oldData1 == oldData2
        case (.success(let data1), .success(let data2)):
            return data1 == data2
        case (.failure(let message1), .failure(let message2)):
            return message1 == message2
        case (.endOfPaginatedReached(let lastData1), .endOfPaginatedReached(let lastData2)):
            return lastData1 == lastData2
        default:
            return false
        }
    }
}
