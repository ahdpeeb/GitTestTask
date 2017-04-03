//
//  LeftArrowButton.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/21/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class LeftArrowButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setImageForStates()
    }
    
    private func setImageForStates() {
        self.setImage(UIImage(named: "leftArrowDisable"), for: .disabled)
        self.setImage(UIImage(named: "leftArrowEnable"), for: .normal)
    }
}
