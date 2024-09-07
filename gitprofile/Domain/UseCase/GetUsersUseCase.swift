//
//  GetPaginatedUsersUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

class GetUsersUseCase {
    
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func execute() async -> LoadableViewState<[UserUiModel]> {
        return await dataManager.loadUsers()
            .fold(onSuccess: { users in
                .success(data: users.map { user in
                    UserUiModel(
                        id: user.id!,
                        login: user.login!,
                        avatarUrl: user.avatarUrl
                    )
                })
            }, onFailure: { error in
                .failure(message: error.localizedDescription)
            })
    }
}

enum UsersViewState<T> {
    case initial
    case success(repos: T)
    case failure(message: String)
}

enum LoadableViewState<T> {
    case initial
    case loaded(oldData: T)
    case success(data: T)
    case failure(message: String)
}

struct UserUiModel {
    var id: Int
    var login: String
    var avatarUrl: String?
}
//
//extension LoadableViewState: Equatable where T: Equatable {
//    static func == (lhs: LoadableViewState<T>, rhs: LoadableViewState<T>) -> Bool {
//            switch (lhs, rhs) {
//            case (.initial, .initial):
//                return true
//            case (.loaded(let lhsOldRepos), .loaded(let rhsOldRepos)):
//                return lhsOldRepos == rhsOldRepos
//            case (.success(let lhsRepos), .success(let rhsRepos)):
//                return lhsRepos == rhsRepos
//            case (.failure(let lhsMessage), .failure(let rhsMessage)):
//                return lhsMessage == rhsMessage
//            default:
//                return false
//            }
//        }
//}
