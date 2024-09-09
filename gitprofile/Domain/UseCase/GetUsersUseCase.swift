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

struct UserUiModel: Equatable, Hashable {
    var id: Int
    var login: String
    var avatarUrl: String?
}
