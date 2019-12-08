//
//  Order.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 28.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public struct Order: Codable {
    
    let orderNumber: String
    let resultingTrades: [TradeResult]?
    let fee: String
    let clientOrderId: String
    let currencyPair: String
    
    struct TradeResult: Codable {
        let amount: String
        let date: String
        let rate: String
        let total: String
        let tradeID: String
        let type: String
    }
}
