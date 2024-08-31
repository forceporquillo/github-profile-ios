//
//  UserDetails.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import Foundation

// MARK: UserDetails
struct UserDetailsResponse: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
    let name, company, blog: String?
    let location, email: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int?
    let createdAt, updatedAt: String?

    static func empty() -> UserDetailsResponse {
        return UserDetailsResponse(
            login: nil,
            id: nil,
            nodeID: nil,
            avatarURL: nil,
            gravatarID: nil,
            url: nil,
            htmlURL: nil,
            followersURL: nil,
            followingURL: nil,
            gistsURL: nil,
            starredURL: nil,
            subscriptionsURL: nil,
            organizationsURL: nil,
            reposURL: nil,
            eventsURL: nil,
            receivedEventsURL: nil,
            type: nil,
            siteAdmin: nil,
            name: nil,
            company: nil,
            blog: nil,
            location: nil,
            email: nil,
            hireable: nil,
            bio: nil,
            twitterUsername: nil,
            publicRepos: nil,
            publicGists: nil,
            followers: nil,
            following: nil,
            createdAt: nil,
            updatedAt: nil
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case name, company, blog, location, email, hireable, bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
