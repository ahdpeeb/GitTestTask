//
//  User.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import ObjectMapper

class User: BaseModel {
    var login: String?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var html_url: String?
    var followers_url: String?
    var following_url: String?
    var gists_url: String?
    var starred_url: String?
    var subscriptions_url: String?
    var organizations_url: String?
    var repos_url: String?
    var events_url: String?
    var received_events_url: String?
    var type: String?
    var site_admin: Bool?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: String?
    var bio: String?
    var public_repos: String?
    var public_gists: String?
    var followers: String?
    var following: String?
    var created_at: String?
    var updated_at: String?
    var uprivate_gistsrl: String?
    var total_private_repos: String?
    var owned_private_repos: String?
    var disk_usage: String?
    var collaborators: String?
    var disk_two_factor_authenticationusage: String?
    var plan: Plan?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

class Plan: Mappable {
    var name: String?
    var space: Double?
    var collaborators: Int?
    var private_repos: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        space <- map["space"]
        collaborators <- map["collaborators"]
        private_repos <- map["private_repos"]
    }
}
