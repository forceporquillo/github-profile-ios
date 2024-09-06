//
//  StarredRepoResponse.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

struct StarredRepoResponse: Codable {

  var id                       : Int?      = nil
  var nodeId                   : String?   = nil
  var name                     : String?   = nil
  var fullName                 : String?   = nil
  var isPrivate                : Bool?     = nil
  var owner                    : Owner?    = Owner()
  var htmlUrl                  : String?   = nil
  var description              : String?   = nil
  var fork                     : Bool?     = nil
  var url                      : String?   = nil
  var forksUrl                 : String?   = nil
  var keysUrl                  : String?   = nil
  var collaboratorsUrl         : String?   = nil
  var teamsUrl                 : String?   = nil
  var hooksUrl                 : String?   = nil
  var issueEventsUrl           : String?   = nil
  var eventsUrl                : String?   = nil
  var assigneesUrl             : String?   = nil
  var branchesUrl              : String?   = nil
  var tagsUrl                  : String?   = nil
  var blobsUrl                 : String?   = nil
  var gitTagsUrl               : String?   = nil
  var gitRefsUrl               : String?   = nil
  var treesUrl                 : String?   = nil
  var statusesUrl              : String?   = nil
  var languagesUrl             : String?   = nil
  var stargazersUrl            : String?   = nil
  var contributorsUrl          : String?   = nil
  var subscribersUrl           : String?   = nil
  var subscriptionUrl          : String?   = nil
  var commitsUrl               : String?   = nil
  var gitCommitsUrl            : String?   = nil
  var commentsUrl              : String?   = nil
  var issueCommentUrl          : String?   = nil
  var contentsUrl              : String?   = nil
  var compareUrl               : String?   = nil
  var mergesUrl                : String?   = nil
  var archiveUrl               : String?   = nil
  var downloadsUrl             : String?   = nil
  var issuesUrl                : String?   = nil
  var pullsUrl                 : String?   = nil
  var milestonesUrl            : String?   = nil
  var notificationsUrl         : String?   = nil
  var labelsUrl                : String?   = nil
  var releasesUrl              : String?   = nil
  var deploymentsUrl           : String?   = nil
  var createdAt                : String?   = nil
  var updatedAt                : String?   = nil
  var pushedAt                 : String?   = nil
  var gitUrl                   : String?   = nil
  var sshUrl                   : String?   = nil
  var cloneUrl                 : String?   = nil
  var svnUrl                   : String?   = nil
  var homepage                 : String?   = nil
  var size                     : Int?      = nil
  var stargazersCount          : Int?      = nil
  var watchersCount            : Int?      = nil
  var language                 : String?   = nil
  var hasIssues                : Bool?     = nil
  var hasProjects              : Bool?     = nil
  var hasDownloads             : Bool?     = nil
  var hasWiki                  : Bool?     = nil
  var hasPages                 : Bool?     = nil
  var hasDiscussions           : Bool?     = nil
  var forksCount               : Int?      = nil
  var mirrorUrl                : String?   = nil
  var archived                 : Bool?     = nil
  var disabled                 : Bool?     = nil
  var openIssuesCount          : Int?      = nil
//  var license                  : License?  = License()
  var allowForking             : Bool?     = nil
  var isTemplate               : Bool?     = nil
  var webCommitSignoffRequired : Bool?     = nil
  var topics                   : [String]? = []
  var visibility               : String?   = nil
  var forks                    : Int?      = nil
  var openIssues               : Int?      = nil
  var watchers                 : Int?      = nil
  var defaultBranch            : String?   = nil

  enum CodingKeys: String, CodingKey {

    case id                       = "id"
    case nodeId                   = "node_id"
    case name                     = "name"
    case fullName                 = "full_name"
    case isPrivate                = "private"
    case owner                    = "owner"
    case htmlUrl                  = "html_url"
    case description              = "description"
    case fork                     = "fork"
    case url                      = "url"
    case forksUrl                 = "forks_url"
    case keysUrl                  = "keys_url"
    case collaboratorsUrl         = "collaborators_url"
    case teamsUrl                 = "teams_url"
    case hooksUrl                 = "hooks_url"
    case issueEventsUrl           = "issue_events_url"
    case eventsUrl                = "events_url"
    case assigneesUrl             = "assignees_url"
    case branchesUrl              = "branches_url"
    case tagsUrl                  = "tags_url"
    case blobsUrl                 = "blobs_url"
    case gitTagsUrl               = "git_tags_url"
    case gitRefsUrl               = "git_refs_url"
    case treesUrl                 = "trees_url"
    case statusesUrl              = "statuses_url"
    case languagesUrl             = "languages_url"
    case stargazersUrl            = "stargazers_url"
    case contributorsUrl          = "contributors_url"
    case subscribersUrl           = "subscribers_url"
    case subscriptionUrl          = "subscription_url"
    case commitsUrl               = "commits_url"
    case gitCommitsUrl            = "git_commits_url"
    case commentsUrl              = "comments_url"
    case issueCommentUrl          = "issue_comment_url"
    case contentsUrl              = "contents_url"
    case compareUrl               = "compare_url"
    case mergesUrl                = "merges_url"
    case archiveUrl               = "archive_url"
    case downloadsUrl             = "downloads_url"
    case issuesUrl                = "issues_url"
    case pullsUrl                 = "pulls_url"
    case milestonesUrl            = "milestones_url"
    case notificationsUrl         = "notifications_url"
    case labelsUrl                = "labels_url"
    case releasesUrl              = "releases_url"
    case deploymentsUrl           = "deployments_url"
    case createdAt                = "created_at"
    case updatedAt                = "updated_at"
    case pushedAt                 = "pushed_at"
    case gitUrl                   = "git_url"
    case sshUrl                   = "ssh_url"
    case cloneUrl                 = "clone_url"
    case svnUrl                   = "svn_url"
    case homepage                 = "homepage"
    case size                     = "size"
    case stargazersCount          = "stargazers_count"
    case watchersCount            = "watchers_count"
    case language                 = "language"
    case hasIssues                = "has_issues"
    case hasProjects              = "has_projects"
    case hasDownloads             = "has_downloads"
    case hasWiki                  = "has_wiki"
    case hasPages                 = "has_pages"
    case hasDiscussions           = "has_discussions"
    case forksCount               = "forks_count"
    case mirrorUrl                = "mirror_url"
    case archived                 = "archived"
    case disabled                 = "disabled"
    case openIssuesCount          = "open_issues_count"
//    case license                  = "license"
    case allowForking             = "allow_forking"
    case isTemplate               = "is_template"
    case webCommitSignoffRequired = "web_commit_signoff_required"
    case topics                   = "topics"
    case visibility               = "visibility"
    case forks                    = "forks"
    case openIssues               = "open_issues"
    case watchers                 = "watchers"
    case defaultBranch            = "default_branch"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id                       = try values.decodeIfPresent(Int.self      , forKey: .id                       )
    nodeId                   = try values.decodeIfPresent(String.self   , forKey: .nodeId                   )
    name                     = try values.decodeIfPresent(String.self   , forKey: .name                     )
    fullName                 = try values.decodeIfPresent(String.self   , forKey: .fullName                 )
    isPrivate                = try values.decodeIfPresent(Bool.self     , forKey: .isPrivate                )
    owner                    = try values.decodeIfPresent(Owner.self    , forKey: .owner                    )
    htmlUrl                  = try values.decodeIfPresent(String.self   , forKey: .htmlUrl                  )
    description              = try values.decodeIfPresent(String.self   , forKey: .description              )
    fork                     = try values.decodeIfPresent(Bool.self     , forKey: .fork                     )
    url                      = try values.decodeIfPresent(String.self   , forKey: .url                      )
    forksUrl                 = try values.decodeIfPresent(String.self   , forKey: .forksUrl                 )
    keysUrl                  = try values.decodeIfPresent(String.self   , forKey: .keysUrl                  )
    collaboratorsUrl         = try values.decodeIfPresent(String.self   , forKey: .collaboratorsUrl         )
    teamsUrl                 = try values.decodeIfPresent(String.self   , forKey: .teamsUrl                 )
    hooksUrl                 = try values.decodeIfPresent(String.self   , forKey: .hooksUrl                 )
    issueEventsUrl           = try values.decodeIfPresent(String.self   , forKey: .issueEventsUrl           )
    eventsUrl                = try values.decodeIfPresent(String.self   , forKey: .eventsUrl                )
    assigneesUrl             = try values.decodeIfPresent(String.self   , forKey: .assigneesUrl             )
    branchesUrl              = try values.decodeIfPresent(String.self   , forKey: .branchesUrl              )
    tagsUrl                  = try values.decodeIfPresent(String.self   , forKey: .tagsUrl                  )
    blobsUrl                 = try values.decodeIfPresent(String.self   , forKey: .blobsUrl                 )
    gitTagsUrl               = try values.decodeIfPresent(String.self   , forKey: .gitTagsUrl               )
    gitRefsUrl               = try values.decodeIfPresent(String.self   , forKey: .gitRefsUrl               )
    treesUrl                 = try values.decodeIfPresent(String.self   , forKey: .treesUrl                 )
    statusesUrl              = try values.decodeIfPresent(String.self   , forKey: .statusesUrl              )
    languagesUrl             = try values.decodeIfPresent(String.self   , forKey: .languagesUrl             )
    stargazersUrl            = try values.decodeIfPresent(String.self   , forKey: .stargazersUrl            )
    contributorsUrl          = try values.decodeIfPresent(String.self   , forKey: .contributorsUrl          )
    subscribersUrl           = try values.decodeIfPresent(String.self   , forKey: .subscribersUrl           )
    subscriptionUrl          = try values.decodeIfPresent(String.self   , forKey: .subscriptionUrl          )
    commitsUrl               = try values.decodeIfPresent(String.self   , forKey: .commitsUrl               )
    gitCommitsUrl            = try values.decodeIfPresent(String.self   , forKey: .gitCommitsUrl            )
    commentsUrl              = try values.decodeIfPresent(String.self   , forKey: .commentsUrl              )
    issueCommentUrl          = try values.decodeIfPresent(String.self   , forKey: .issueCommentUrl          )
    contentsUrl              = try values.decodeIfPresent(String.self   , forKey: .contentsUrl              )
    compareUrl               = try values.decodeIfPresent(String.self   , forKey: .compareUrl               )
    mergesUrl                = try values.decodeIfPresent(String.self   , forKey: .mergesUrl                )
    archiveUrl               = try values.decodeIfPresent(String.self   , forKey: .archiveUrl               )
    downloadsUrl             = try values.decodeIfPresent(String.self   , forKey: .downloadsUrl             )
    issuesUrl                = try values.decodeIfPresent(String.self   , forKey: .issuesUrl                )
    pullsUrl                 = try values.decodeIfPresent(String.self   , forKey: .pullsUrl                 )
    milestonesUrl            = try values.decodeIfPresent(String.self   , forKey: .milestonesUrl            )
    notificationsUrl         = try values.decodeIfPresent(String.self   , forKey: .notificationsUrl         )
    labelsUrl                = try values.decodeIfPresent(String.self   , forKey: .labelsUrl                )
    releasesUrl              = try values.decodeIfPresent(String.self   , forKey: .releasesUrl              )
    deploymentsUrl           = try values.decodeIfPresent(String.self   , forKey: .deploymentsUrl           )
    createdAt                = try values.decodeIfPresent(String.self   , forKey: .createdAt                )
    updatedAt                = try values.decodeIfPresent(String.self   , forKey: .updatedAt                )
    pushedAt                 = try values.decodeIfPresent(String.self   , forKey: .pushedAt                 )
    gitUrl                   = try values.decodeIfPresent(String.self   , forKey: .gitUrl                   )
    sshUrl                   = try values.decodeIfPresent(String.self   , forKey: .sshUrl                   )
    cloneUrl                 = try values.decodeIfPresent(String.self   , forKey: .cloneUrl                 )
    svnUrl                   = try values.decodeIfPresent(String.self   , forKey: .svnUrl                   )
    homepage                 = try values.decodeIfPresent(String.self   , forKey: .homepage                 )
    size                     = try values.decodeIfPresent(Int.self      , forKey: .size                     )
    stargazersCount          = try values.decodeIfPresent(Int.self      , forKey: .stargazersCount          )
    watchersCount            = try values.decodeIfPresent(Int.self      , forKey: .watchersCount            )
    language                 = try values.decodeIfPresent(String.self   , forKey: .language                 )
    hasIssues                = try values.decodeIfPresent(Bool.self     , forKey: .hasIssues                )
    hasProjects              = try values.decodeIfPresent(Bool.self     , forKey: .hasProjects              )
    hasDownloads             = try values.decodeIfPresent(Bool.self     , forKey: .hasDownloads             )
    hasWiki                  = try values.decodeIfPresent(Bool.self     , forKey: .hasWiki                  )
    hasPages                 = try values.decodeIfPresent(Bool.self     , forKey: .hasPages                 )
    hasDiscussions           = try values.decodeIfPresent(Bool.self     , forKey: .hasDiscussions           )
    forksCount               = try values.decodeIfPresent(Int.self      , forKey: .forksCount               )
    mirrorUrl                = try values.decodeIfPresent(String.self   , forKey: .mirrorUrl                )
    archived                 = try values.decodeIfPresent(Bool.self     , forKey: .archived                 )
    disabled                 = try values.decodeIfPresent(Bool.self     , forKey: .disabled                 )
    openIssuesCount          = try values.decodeIfPresent(Int.self      , forKey: .openIssuesCount          )
//    license                  = try values.decodeIfPresent(License.self  , forKey: .license                  )
    allowForking             = try values.decodeIfPresent(Bool.self     , forKey: .allowForking             )
    isTemplate               = try values.decodeIfPresent(Bool.self     , forKey: .isTemplate               )
    webCommitSignoffRequired = try values.decodeIfPresent(Bool.self     , forKey: .webCommitSignoffRequired )
    topics                   = try values.decodeIfPresent([String].self , forKey: .topics                   )
    visibility               = try values.decodeIfPresent(String.self   , forKey: .visibility               )
    forks                    = try values.decodeIfPresent(Int.self      , forKey: .forks                    )
    openIssues               = try values.decodeIfPresent(Int.self      , forKey: .openIssues               )
    watchers                 = try values.decodeIfPresent(Int.self      , forKey: .watchers                 )
    defaultBranch            = try values.decodeIfPresent(String.self   , forKey: .defaultBranch            )
 
  }

  init() {

  }

}

struct Owner: Codable {

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

}
