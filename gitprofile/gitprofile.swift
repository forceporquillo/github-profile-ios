//
//  gitprofile.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/18/24.
//

import Foundation

struct UserResponse: Codable {
    let gistsUrl: String?
    let reposUrl: String?
    let followingUrl: String?
    let starredUrl: String?
    let login: String?
    let followersUrl: String?
    let type: String?
    let url: String?
    let subscriptionsUrl: String?
    let receivedEventsUrl: String?
    let avatarUrl: String?
    let eventsUrl: String?
    let htmlUrl: String?
    let siteAdmin: Bool?
    let id: Int?
    let gravatarId: String?
    let nodeId: String?
    let organizationsUrl: String?

    enum CodingKeys: String, CodingKey {
        case gistsUrl = "gists_url"
        case reposUrl = "repos_url"
        case followingUrl = "following_url"
        case starredUrl = "starred_url"
        case login
        case followersUrl = "followers_url"
        case type
        case url
        case subscriptionsUrl = "subscriptions_url"
        case receivedEventsUrl = "received_events_url"
        case avatarUrl = "avatar_url"
        case eventsUrl = "events_url"
        case htmlUrl = "html_url"
        case siteAdmin = "site_admin"
        case id
        case gravatarId = "gravatar_id"
        case nodeId = "node_id"
        case organizationsUrl = "organizations_url"
    }
}
