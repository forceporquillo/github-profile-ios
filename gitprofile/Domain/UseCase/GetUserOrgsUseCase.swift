//
//  GetUserOrgsUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

class GetUserOrgsUseCase {
    
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func execute(username: String) async -> LoadableViewState<[UserOrgsUiModel]> {
        return await dataManager.findUserOrgs(username: username)
            .fold(onSuccess: { orgs in
                return .success(data: orgs.map { org in
                    UserOrgsUiModel(
                        id: org.id!,
                        name: org.login ?? "",
                        avatar: org.avatarUrl ?? "",
                        description: org.description ?? ""
                    )
                })
            }, onFailure: { error in
                return .failure(message: error.localizedDescription)
            })
    }
}

struct UserOrgsUiModel {
    var id: Int
    var name: String
    var avatar: String
    var description: String
}

