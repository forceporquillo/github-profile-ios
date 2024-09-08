//
//  SearchUserUseCase.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/7/24.
//

class SearchUserUseCase {
    
    private let dataManager: UserDataManager
    
    init(_ dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func execute(username: String) async -> LoadableViewState<[UserUiModel]> {
        let cleanQueryName = username.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let filtered = await dataManager.loadUsers()
            .fold(onSuccess: { users in
                users.filter {
                    guard let login = $0.login, let _ = $0.id else {
                        return false
                    }
                    return login.starts(with: cleanQueryName)
                }
            }, onFailure: { error in [] })
        
        if !filtered.isEmpty {
            return .loaded(oldData: filtered
                .map { response in
                    return UserUiModel(
                        id: response.id!,
                        login: response.login!,
                        avatarUrl: response.avatarUrl
                    )
                })
        }
        
        return await dataManager.findUserDetails(username: cleanQueryName)
            .fold(onSuccess: { details in
                    .loaded(oldData: [
                        UserUiModel(
                            id: details.id ?? -1,
                            login: details.login ?? "",
                            avatarUrl: details.avatarUrl ?? ""
                        )
                    ])
            }, onFailure: { error in .failure(message: error.localizedDescription) })
    }
}
