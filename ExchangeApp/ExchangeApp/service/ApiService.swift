//
//  ApiService.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation


/// Protocol for exchange platforms implementation
public protocol ApiService {
    
    
    /// Get cryptocurrency pairs from exchange platform
    ///
    /// - Parameter completion: array of pairs or error
    /// - Returns: array of pairs or error
    func getPairs(completion: @escaping (Result<[EntryList.Pair],ErrorMessage>) -> Void)
    
    
    /// Get candleSticks for chart from exchange platform
    ///
    /// - Parameters:
    ///   - pairName: name of crypto pair
    ///   - start: start time in seconds
    ///   - end: end time in seconds
    ///   - period: time between candles
    ///   - completion: array of candleSticks or error
    /// - Returns: array of candleSticks or error
    func getChart(pairName: String, start: String, end: String, period: String, completion: @escaping (Result<[Chart],ErrorMessage>) -> Void)
    
    
    /// Get info about wallet from exchange platform
    ///
    /// - Parameter completion: array of wallet currencies or error
    /// - Returns: array of wallet currencies or error
    func getWallet(completion: @escaping (Result<[EntryList.Currency],ErrorMessage>) -> Void)
    
    func getWalletAddress(completion: @escaping (Result<[EntryList.Address],ErrorMessage>) -> Void)
    
    func getOrders(completion: @escaping (Result<[SimpleOrder], ErrorMessage>) -> Void)
    
    /// Get info about trade orders
    ///
    /// - Parameters:
    ///   - currencyPair: name of cryptocurrency pair
    ///   - rate: price
    ///   - amount: amount of curency
    ///   - completion: order or error
    /// - Returns: order or error
    func buyOrder(currencyPair:String, rate:String, amount: String, completion: @escaping (Result<Order,ErrorMessage>) -> Void)
    
    /// Get info about trade orders
    ///
    /// - Parameters:
    ///   - currencyPair: name of cryptocurrency pair
    ///   - rate: price
    ///   - amount: amount of curency
    ///   - completion: order or error
    /// - Returns: order or error
    func sellOrder(currencyPair: String, rate: String, amount: String, completion: @escaping (Result<Order,ErrorMessage>) -> Void)
}
