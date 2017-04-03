//
//  String + Сurrency.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/21/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

extension String {
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        let formatter = NumberFormatter()
//        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue
        let number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else { return "" }
        
        let summ = formatter.string(from: number)!
        return summ.replacingOccurrences(of: ",", with: ".")
    }
}
