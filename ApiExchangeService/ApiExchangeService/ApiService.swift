//
//  ApiService.swift
//  ApiExchangeService
//
//  Created by Юрий Нориков on 16.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public protocol ApiService {
    func getPairs()
    func getChart(pairName: String, start: String, end: String, period: String)
    func getWallet()
    func buyOrder(currencyPair:String, rate:String, amount: String)
    func sellOrder(currencyPair: String, rate: String, amount: String)
    
}
