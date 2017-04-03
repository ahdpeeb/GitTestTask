//
//  String + extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/3/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

extension String {
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        
        return nil
    }
    
    func nullifyIfEmpty() -> String? {
        return self.isEmpty ? nil : self
    }
    
    func removeLastChar() -> String {
        return self.substring(to: self.index(before: self.endIndex))
    }
}

