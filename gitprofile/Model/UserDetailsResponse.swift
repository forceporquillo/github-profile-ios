//
//  UserDetails.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import Foundation

// MARK: UserDetailsResponse
struct UserDetailsResponse: Codable {
    
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
    var name              : String? = nil
    var company           : String? = nil
    var blog              : String? = nil
    var location          : String? = nil
    var email             : String? = nil
    var hireable          : Bool?   = nil
    var bio               : String? = nil
    var twitterUsername   : String? = nil
    var publicRepos       : Int?    = nil
    var publicGists       : Int?    = nil
    var followers         : Int?    = nil
    var following         : Int?    = nil
    var createdAt         : String? = nil
    var updatedAt         : String? = nil

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
      case name              = "name"
      case company           = "company"
      case blog              = "blog"
      case location          = "location"
      case email             = "email"
      case hireable          = "hireable"
      case bio               = "bio"
      case twitterUsername   = "twitter_username"
      case publicRepos       = "public_repos"
      case publicGists       = "public_gists"
      case followers         = "followers"
      case following         = "following"
      case createdAt         = "created_at"
      case updatedAt         = "updated_at"
    
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
      name              = try values.decodeIfPresent(String.self , forKey: .name              )
      company           = try values.decodeIfPresent(String.self , forKey: .company           )
      blog              = try values.decodeIfPresent(String.self , forKey: .blog              )
      location          = try values.decodeIfPresent(String.self , forKey: .location          )
      email             = try values.decodeIfPresent(String.self , forKey: .email             )
      hireable          = try values.decodeIfPresent(Bool.self   , forKey: .hireable          )
      bio               = try values.decodeIfPresent(String.self , forKey: .bio               )
      twitterUsername   = try values.decodeIfPresent(String.self , forKey: .twitterUsername   )
      publicRepos       = try values.decodeIfPresent(Int.self    , forKey: .publicRepos       )
      publicGists       = try values.decodeIfPresent(Int.self    , forKey: .publicGists       )
      followers         = try values.decodeIfPresent(Int.self    , forKey: .followers         )
      following         = try values.decodeIfPresent(Int.self    , forKey: .following         )
      createdAt         = try values.decodeIfPresent(String.self , forKey: .createdAt         )
      updatedAt         = try values.decodeIfPresent(String.self , forKey: .updatedAt         )
   
    }

    init() {

    }

}
