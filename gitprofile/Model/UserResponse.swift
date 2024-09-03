//
//  UserResponse.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

struct UserResponse: Codable, Hashable {
    
    var login             : String? = nil
    var id                : Int?    = nil
    var nodeId            : String? = nil
    var avatarUrl         : String? = nil
    var gravatarId        : String? = nil
    var url               : String? = nil
    var htmlUrl           : String? = nil
    var followersUrl      : String? = nil
    var followingUrl      : String? = nil
    var gistsUrl          : String? = nil
    var starredUrl        : String? = nil
    var subscriptionsUrl  : String? = nil
    var organizationsUrl  : String? = nil
    var reposUrl          : String? = nil
    var eventsUrl         : String? = nil
    var receivedEventsUrl : String? = nil
    var type              : String? = nil
    var siteAdmin         : Bool?   = nil
    
    enum CodingKeys: String, CodingKey {
        
        case login             = "login"
        case id                = "id"
        case nodeId            = "node_id"
        case avatarUrl         = "avatar_url"
        case gravatarId        = "gravatar_id"
        case url               = "url"
        case htmlUrl           = "html_url"
        case followersUrl      = "followers_url"
        case followingUrl      = "following_url"
        case gistsUrl          = "gists_url"
        case starredUrl        = "starred_url"
        case subscriptionsUrl  = "subscriptions_url"
        case organizationsUrl  = "organizations_url"
        case reposUrl          = "repos_url"
        case eventsUrl         = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type              = "type"
        case siteAdmin         = "site_admin"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        login             = try values.decodeIfPresent(String.self , forKey: .login             )
        id                = try values.decodeIfPresent(Int.self    , forKey: .id                )
        nodeId            = try values.decodeIfPresent(String.self , forKey: .nodeId            )
        avatarUrl         = try values.decodeIfPresent(String.self , forKey: .avatarUrl         )
        gravatarId        = try values.decodeIfPresent(String.self , forKey: .gravatarId        )
        url               = try values.decodeIfPresent(String.self , forKey: .url               )
        htmlUrl           = try values.decodeIfPresent(String.self , forKey: .htmlUrl           )
        followersUrl      = try values.decodeIfPresent(String.self , forKey: .followersUrl      )
        followingUrl      = try values.decodeIfPresent(String.self , forKey: .followingUrl      )
        gistsUrl          = try values.decodeIfPresent(String.self , forKey: .gistsUrl          )
        starredUrl        = try values.decodeIfPresent(String.self , forKey: .starredUrl        )
        subscriptionsUrl  = try values.decodeIfPresent(String.self , forKey: .subscriptionsUrl  )
        organizationsUrl  = try values.decodeIfPresent(String.self , forKey: .organizationsUrl  )
        reposUrl          = try values.decodeIfPresent(String.self , forKey: .reposUrl          )
        eventsUrl         = try values.decodeIfPresent(String.self , forKey: .eventsUrl         )
        receivedEventsUrl = try values.decodeIfPresent(String.self , forKey: .receivedEventsUrl )
        type              = try values.decodeIfPresent(String.self , forKey: .type              )
        siteAdmin         = try values.decodeIfPresent(Bool.self   , forKey: .siteAdmin         )
        
    }
    
    init() {
        
    }
    
    static func == (lhs: UserResponse, rhs: UserResponse) -> Bool {
        return lhs.id == rhs.id && lhs.nodeId == rhs.nodeId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(nodeId)
    }
}
