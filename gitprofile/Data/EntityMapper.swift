//
//  EntityMapper.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/5/24.
//

import Foundation

protocol EntityMapper {
    associatedtype From
    associatedtype To
    
    func map(from entity: From) -> To
}
