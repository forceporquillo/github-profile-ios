//
//  GetStarredReposUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

class GetStarredReposUseCase {
    
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func execute(username: String) async -> LoadableViewState<[UserStarredReposUiModel]> {
        return await dataManager.findUserStarredRepos(username: username)
            .fold(onSuccess: { starred in
                let (starred, endOfPagination) = (starred.data, starred.endOfPagination)
                let mappedResult = starred.map { repo in
                    UserStarredReposUiModel(
                        id: repo.id!,
                        name: repo.name ?? "",
                        ownerName: repo.owner?.login ?? "",
                        avatar: repo.owner?.avatarUrl,
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

struct UserStarredReposUiModel: Equatable {
    var id: Int
    var name: String
    var ownerName: String
    var avatar: String?
    var description: String
    var starredCount: Int
    var language: String?
}

