//
//  StarredReposRepository.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation
import os

protocol UserReposRepository<Data> {
    
    associatedtype Data
    
    func saveData(_ username: String, _ repos: [Data]?, _ next: Int, _ endOfPaginationReached: Bool)
    func getData(username: String) -> [Data]
    func getNextPage(username: String) -> Int
    func isEndOfPagination(for username: String) -> Bool?
}

class PagingRepositoryFactory {
    
    private static let logger = LoggerFactory.create(clazz: PagingRepositoryFactory.self)
    
    private static var sharedInstance: [ObjectIdentifier: any UserReposRepository] = [:]
    
    static func create<T: Hashable>(for clazzDelegate: T.Type) -> any UserReposRepository<T> {
        let key = ObjectIdentifier(clazzDelegate)
        logger.log(message: "Instance indentifier \(key)")
        if let existingInstance = sharedInstance[key] as? InMemoryPagingDataRepository<T> {
            logger.log(message: "Existing instance \(type(of: existingInstance.self))")
            return existingInstance
        } else {
            let newInstance = InMemoryPagingDataRepository<T>()
            logger.log(message: "Creating new instance: \(type(of: newInstance.self))")
            sharedInstance[key] = newInstance
            return newInstance
        }
    }
}

class InMemoryPagingDataRepository<T : Hashable>: UserReposRepository {
    
    typealias Data = T
    
    private let logger = LoggerFactory.create(clazz: InMemoryPagingDataRepository.self)
    
    private var userRepos: [String: [Data]] = [:]
    private var nextPage: [String: Int] = [:]
    private var endOfPaginationReached: [String: Bool] = [:]
    
    func saveData(_ username: String, _ repos: [Data]?, _ next: Int, _ endOfPaginationReached: Bool) {
        self.saveNextPage(username: username, page: next)
        self.endOfPaginationReached[username] = endOfPaginationReached
        guard let repos = repos else {
            return
        }
        if var existingRepos = self.userRepos[username] {
            existingRepos.append(contentsOf: repos)
            self.userRepos[username] = existingRepos
        } else {
            self.userRepos[username] = repos
        }
    }
    
    func getData(username: String) -> [Data] {
        guard let data = self.userRepos[username] else { return [] }
        logger.log(message: "retrieving cache data for \(username) size \(data.count)")
        return data
    }
    
    func isEndOfPagination(for username: String) -> Bool? {
        logger.log(message: "is end of pagination for user \(username) \(self.nextPage[username] ?? 1)")
        return self.endOfPaginationReached[username]
    }
    
    func getNextPage(username: String) -> Int {
        logger.log(message: "Retrieving next page \(self.nextPage[username] ?? 1)")
        return self.nextPage[username] ?? 1
    }
    
    private func saveNextPage(username: String, page: Int) {
        logger.log(message: "Saving next page: \(page)")
        let oldPage = self.nextPage[username]
        logger.log(message: "Previous page: \(String(describing: oldPage))")
        let nextPage = Int(page)
        self.nextPage[username] = nextPage
    }
}
