//
//  UserRepository.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

final class UserRepositoryImpl : UsersRepository {
    
    private let component = UserDataComponentFactory.create()

    private var users: Set<UserResponse> = []
    private var since = 0
   
    func saveUsers(users: [UserResponse]?) {
        guard let users = users else {
            return
        }
        self.users.formUnion(users)
    }

    func getUsers() -> [UserResponse] {
        return self.users.sorted {
            guard let leftId = $0.id else { return false }
            guard let rightId = $1.id else { return false }
            return leftId < rightId
        }
    }

    func getNextPage() -> Int {
        return self.since
    }

    func saveNextPage(since: Int) {
        self.since = since
    }
}

protocol UsersRepository {
    
    func saveUsers(users: [UserResponse]?)
    func getUsers() -> [UserResponse]
    
    func saveNextPage(since: Int)
    func getNextPage() -> Int
}
