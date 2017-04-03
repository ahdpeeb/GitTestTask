//
//  UIViewController + Extension.swift
//  Compas
//
//  Created by Nikola Andriiev on 01.11.16.
//  Copyright © 2016 Andriiev.Mykola. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }
}
