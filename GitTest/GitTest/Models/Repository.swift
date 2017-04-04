//
//  Repository.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: BaseModel {
    var name: String?
    var owner: Owner?
    var descriptionDetails: String?
    var url: String?
    var forks_count: Int?
    var language: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        owner <- map["owner"]
        descriptionDetails <- map["description"]
        url <- map["owner"]
        forks_count <- map["owner"]
        language <- map["language"]
    }
}
