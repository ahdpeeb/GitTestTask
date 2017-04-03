//
//  ProtocolExtensions.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/25/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import DropDown

protocol DropDownBinding {
    func bindTo(view: UITextField, with sourсeData: [String], action: @escaping DropDownAction) -> DropDown
}

extension DropDownBinding {
    typealias DropDownAction = (Index, String) -> ()
    func bindTo(view: UITextField, with sourсeData: [String], action: @escaping DropDownAction) -> DropDown {
        let dropDown = DropDown(anchorView: view,
                                selectionAction: action,
                                dataSource: sourсeData,
                                topOffset: CGPoint(x: 0, y: -view.bounds.height),
                                bottomOffset: CGPoint(x: 0, y: view.bounds.height),
                                cellConfiguration: nil,
                                cancelAction: {
                                    view.endEditing(true)
        })
        
        return dropDown
    }
}

protocol DatePickerBinding {
    func bind(datePicker: UIDatePicker, toTextField textField: UITextField, withSelector selector: Selector)
}

extension DatePickerBinding {
    func bind(datePicker: UIDatePicker, toTextField textField: UITextField, withSelector selector: Selector) {
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: selector, for: .valueChanged)
    }
}

