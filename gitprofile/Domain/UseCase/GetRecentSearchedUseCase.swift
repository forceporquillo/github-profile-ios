//
//  GetRecentSearchedUseCase.swift
//  GitHub Profile
//
//  Created by Aljan Porquillo on 4/18/25.
//

import Foundation

class GetRecentSearchedUseCase {
    
    private let cacheManager = CacheManager.shared
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func execute() async -> LoadableViewState<[UserUiModel]> {
        return await dataManager.findAllUserDetails("*")
            .fold(
                onSuccess: { userDetails in
                    return .loaded(
                        oldData: userDetails
                            .compactMap { detail in
                                guard let id = detail.id, let login = detail.login else {
                                    return nil
                                }
                                return UserUiModel(
                                    id: id,
                                    login: login,
                                    avatarUrl: detail.avatarUrl
                                )
                            }
                            .reversed()
                    )
                },
                onFailure: { error in
                    return .failure(message: error.localizedDescription)
                }
            )
    }
}
