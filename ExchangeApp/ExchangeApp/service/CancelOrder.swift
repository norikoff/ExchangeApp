//
//  CancelOrder.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 07.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public struct CancelOrder: Codable {
    
    let success: Int
    let amount: String
    let message: String
    
}
