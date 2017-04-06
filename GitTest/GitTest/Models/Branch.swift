//
//  Branch.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/6/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import ObjectMapper

class Branch: Mappable {
    var name: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }
}
