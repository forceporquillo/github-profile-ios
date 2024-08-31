//
//  UsersViewModel.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import Foundation

@MainActor
class UsersViewModel : ObservableObject {
    
    @Published
    var users: [UserResponse] = []

    func fetchUsers() async throws {
        let url = URL(string: "https://api.github.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        let userData = try decoder.decode([UserResponse].self, from: data)
        users.append(contentsOf: userData)
    }
}
