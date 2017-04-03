//
//  UICollectionView + Extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/23/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerCell(withClass cls: AnyClass?) {
        if let cls = cls {
            let name = String(describing: cls.self)
            let cell = UINib.nibName(name)
            self.register(cell, forCellWithReuseIdentifier: name)
        }
    }
    
    func dequeueCell<T>(cls: T.Type, indexPath path: IndexPath) -> T {
        let clsString = String(describing: T.self)
        return self.dequeueReusableCell(withReuseIdentifier: clsString, for: path) as! T
    }
}
