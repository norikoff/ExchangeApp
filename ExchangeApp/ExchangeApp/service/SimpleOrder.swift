//
//  SimpleOrder.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 03.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation


public struct SimpleOrder: Codable {
    let globalTradeID: Int64
    let tradeID: Int64
    let date: String
    let type: String
    let rate: String
    let amount: String
    let total: String
    let orderNumber: String
}
