//
//  TextFieldFactory.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 08.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import UIKit


class TextFieldFactory {
    
   static func createTextField(title: String) -> UITextField {
        let textField = UITextField()
        
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.textAlignment = .center
        textField.attributedPlaceholder =
            NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.layer.cornerRadius = 20
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}


