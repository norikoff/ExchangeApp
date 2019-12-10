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
    /// - Parameter completion: nil
    /// - Returns: array of wallet currencies or error
    func getWallet(completion: @escaping (Result<[EntryList.Currency],ErrorMessage>) -> Void)
    
    /// Get currency addresses
    ///
    /// - Parameter completion:
    /// - Returns:  array of addresses or error
    func getWalletAddress(completion: @escaping (Result<[EntryList.Address],ErrorMessage>) -> Void)
    
    
    /// Get orders info
    ///
    /// - Parameter completion: nil
    /// - Returns: array of orders or error
    func getOrders(completion: @escaping (Result<[EntryList.SimpleOrder.Content], ErrorMessage>) -> Void)
    
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
    
    
    /// Cancel order request
    ///
    /// - Parameters:
    ///   - orderNumber: order number for cancel
    ///   - completion: bool or error
    func cancelOrder(orderNumber: String, completion: @escaping (Result<Bool,ErrorMessage>) -> Void)
}
