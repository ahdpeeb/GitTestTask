//
//  baseModel.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/24/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: NSObject, Mappable {
    var id: Int!
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        super.init()
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
    
    override init() {
        super.init()
    }
}
