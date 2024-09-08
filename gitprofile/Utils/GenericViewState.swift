//
//  GenericViewState.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

import Foundation

enum GenericViewState<T: Equatable> {
    case initial
    case success(repos: T)
    case failure(message: String)
}

extension GenericViewState: Equatable {
    static func == (lhs: GenericViewState<T>, rhs: GenericViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.success(let data1), .success(let data2)):
            return data1 == data2
        case (.failure(let message1), .failure(let message2)):
            return message1 == message2
        default:
            return false
        }
    }
}
