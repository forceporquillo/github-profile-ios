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
    
    func execute() async -> UsersViewState<[UserUiModel]> {
        return await dataManager.loadUsers()
            .fold(onSuccess: { users in
                .success(repos: users.map { user in
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
    case loaded(oldRepos: T)
    case success(repos: T)
    case failure(message: String)
}

struct UserUiModel {
    var id: Int
    var login: String
    var avatarUrl: String?
}
