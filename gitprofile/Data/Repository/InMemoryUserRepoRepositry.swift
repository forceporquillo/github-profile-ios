//
//  StarredReposRepository.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

class InMemoryUserRepoRepositry : UserReposRepository {

    private var userRepos: [String: Set<RepositoriesResponse>] = [:]
    private var nextPage: [String: Int] = [:]

    func saveUserRepos(username: String, repos: [RepositoriesResponse]?) {
        guard let repos = repos else {
            return
        }
        if var existingRepos = self.userRepos[username] {
            existingRepos.formUnion(repos)
            self.userRepos[username] = existingRepos
        } else {
            self.userRepos[username] = Set(repos)
        }
    }
    
    func getUserRepos(username: String) -> [RepositoriesResponse] {
        return self.userRepos[username]?.sorted {
            guard let updatedAtA = $0.updatedAt else { return false }
            guard let updateAtB = $1.updatedAt else { return false }
            return updatedAtA > updateAtB
        } ?? []
    }

    func getNextPage(username: String) -> Int {
        return self.nextPage[username] ?? 1
    }
    
    func saveNextPage(username: String, page: String?) {
        guard let page = page else {
            return
        }
        let oldPage = self.nextPage[username]
        let nextPage = Int(page)
        if oldPage == nextPage {
            self.nextPage[username] = -1
        } else {
            self.nextPage[username] = nextPage
        }
    }
}

protocol UserReposRepository {
    
    func saveUserRepos(username: String, repos: [RepositoriesResponse]?)
    func getUserRepos(username: String) -> [RepositoriesResponse]
    
    func saveNextPage(username: String, page: String?)
    func getNextPage(username: String) -> Int
}
