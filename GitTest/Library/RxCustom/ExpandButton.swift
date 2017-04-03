//
//  ExpandButton.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/28/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class ExpandButton: UIButton {
    
    override func awakeFromNib() {
        self.initialConfig()
    }
    
    private func initialConfig() {
        self.setImage(UIImage(named: "down-arrow"), for: .normal)
        self.setImage(UIImage(named: "up-arrow"), for: .selected)
    }
}
