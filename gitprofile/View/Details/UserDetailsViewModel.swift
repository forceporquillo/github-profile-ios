//
//  UserDetailsViewModel.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/31/24.
//

import Foundation

@MainActor
class UserDetailsViewModel : ObservableObject {
    
    @Published private (set) var isLoading: Bool = true
    @Published private (set) var details: UserDetailsResponse = UserDetailsResponse.empty()
    @Published private (set) var repositories: [RepositoriesResponse] = []

    func fetchDetails(username: String) async throws {
        do {
            self.isLoading = true
            async let details: UserDetailsResponse = fetchDetails(username: username)
            async let repositories: [RepositoriesResponse] = fetchRepositories(username: username)
            let (detailsResult, repositoriesResult) = try await (details, repositories)
            self.details = detailsResult
            self.repositories = repositoriesResult
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
        } catch {
            print("Error fetching details: \(error)")
        }
    }

    func onLoadMore(page: Int) {
        
    }

    private func fetchDetails(username: String) async throws -> UserDetailsResponse {
        let url = URL(string: "https://api.github.com/users/\(username)")!
        let (data, _) = try! await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return try decoder.decode(UserDetailsResponse.self, from: data)
    }

    private func fetchRepositories(username: String) async throws -> [RepositoriesResponse] {
        let url = URL(string: "https://api.github.com/users/\(username)/repos")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([RepositoriesResponse].self, from: data)
            .sorted {
                guard let updatedAtA = $0.updatedAt else { return false }
                guard let updateAtB = $1.updatedAt else { return false }
                return updatedAtA > updateAtB
            }
    }
}
