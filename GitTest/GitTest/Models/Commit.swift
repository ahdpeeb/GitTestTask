    //
//  Commit.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/6/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import ObjectMapper

class Commit: Mappable {
    var committerName: String?
    var committerDate: Date?
    var message: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        committerName <- map["commit.committer.name"]
        committerDate <- (map["commit.committer.date"], ISO8601DiteTransform())
        message <- map["commit.message"]
    }
    
    public func committerDateString() -> String? {
        return self.committerDate?.stringWith(format: "MM-dd-yyyy HH:mm")
    }
}

//DESC transfor git dateString to Date
class ISO8601DiteTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let dateString = value as? String else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: dateString)
        return date
    }
    
    
    func transformToJSON(_ value: Date?) -> JSON? {
       return value.map({ return $0.stringWith(format: "yyyy-MM-dd'T'HH:mm:ssZ") })
    }
}
