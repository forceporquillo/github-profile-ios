//
//  GetPaginatedUserReposUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

class GetUserReposUseCase {
    
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func execute(username: String) async -> [UserReposUiModel] {
        return await dataManager.userReposNetworkCall(username: username)
            .fold(onSuccess: { repos in
                return repos.map { repo in
                    UserReposUiModel(
                        id: repo.id!,
                        name: repo.name ?? "",
                        description: repo.description ?? "",
                        starredCount: repo.stargazersCount ?? 0,
                        language: repo.language
                    )
                }
            }, onFailure: { error in
                return [] as [UserReposUiModel]
            })
    }
}

struct UserReposUiModel {
    var id: Int
    var name: String
    var description: String
    var starredCount: Int
    var language: String?
}


