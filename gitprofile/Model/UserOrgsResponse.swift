//
//  UserOrgsResponse.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

struct UserOrgsResponse: Codable, Hashable {

  var login            : String? = nil
  var id               : Int?    = nil
  var nodeId           : String? = nil
  var url              : String? = nil
  var reposUrl         : String? = nil
  var eventsUrl        : String? = nil
  var hooksUrl         : String? = nil
  var issuesUrl        : String? = nil
  var membersUrl       : String? = nil
  var publicMembersUrl : String? = nil
  var avatarUrl        : String? = nil
  var description      : String? = nil

  enum CodingKeys: String, CodingKey {

    case login            = "login"
    case id               = "id"
    case nodeId           = "node_id"
    case url              = "url"
    case reposUrl         = "repos_url"
    case eventsUrl        = "events_url"
    case hooksUrl         = "hooks_url"
    case issuesUrl        = "issues_url"
    case membersUrl       = "members_url"
    case publicMembersUrl = "public_members_url"
    case avatarUrl        = "avatar_url"
    case description      = "description"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    login            = try values.decodeIfPresent(String.self , forKey: .login            )
    id               = try values.decodeIfPresent(Int.self    , forKey: .id               )
    nodeId           = try values.decodeIfPresent(String.self , forKey: .nodeId           )
    url              = try values.decodeIfPresent(String.self , forKey: .url              )
    reposUrl         = try values.decodeIfPresent(String.self , forKey: .reposUrl         )
    eventsUrl        = try values.decodeIfPresent(String.self , forKey: .eventsUrl        )
    hooksUrl         = try values.decodeIfPresent(String.self , forKey: .hooksUrl         )
    issuesUrl        = try values.decodeIfPresent(String.self , forKey: .issuesUrl        )
    membersUrl       = try values.decodeIfPresent(String.self , forKey: .membersUrl       )
    publicMembersUrl = try values.decodeIfPresent(String.self , forKey: .publicMembersUrl )
    avatarUrl        = try values.decodeIfPresent(String.self , forKey: .avatarUrl        )
    description      = try values.decodeIfPresent(String.self , forKey: .description      )
 
  }

  init() {

  }

}
