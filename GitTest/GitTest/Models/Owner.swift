//
//  Owner.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import ObjectMapper

class Owner: BaseModel {
    var login: String?
    var avatar_url: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        login <- map["login"]
        avatar_url <- map["avatar_url"]
    }
    
}
