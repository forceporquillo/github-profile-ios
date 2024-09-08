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
    
    func execute(username: String) async -> LoadableViewState<[UserReposUiModel]> {
        return await dataManager.findUserRepos(username: username)
            .fold(onSuccess: { repos in
                let (repos, endOfPagination) = (repos.data, repos.endOfPagination)
                let mappedResult = repos.map { repo in
                    UserReposUiModel(
                        id: repo.id!,
                        name: repo.name ?? "",
                        description: repo.description ?? "",
                        starredCount: repo.stargazersCount ?? 0,
                        language: repo.language
                    )
                }
                if endOfPagination {
                    return .endOfPaginatedReached(lastData: mappedResult)
                }
                return .success(data: mappedResult)
            }, onFailure: { error in
                return .failure(message: error.localizedDescription)
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


