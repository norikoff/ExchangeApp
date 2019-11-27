//
//  ApiService.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public protocol ApiService {
    func getPairs(completion: @escaping ([EntryList.Pair], Error?) -> Void)
    func getChart(pairName: String, start: String, end: String, period: String, completion: @escaping ([Chart], Error?) -> Void)
    func getWallet(completion: @escaping ([EntryList.Currency], Error?) -> Void)
    func buyOrder(currencyPair:String, rate:String, amount: String)
    func sellOrder(currencyPair: String, rate: String, amount: String)
}
