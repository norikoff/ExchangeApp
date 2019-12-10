//
//  Currency.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public struct EntryList: Decodable {
    
    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {self.stringValue = stringValue}
        
        var intValue: Int?{return nil}
        init?(intValue: Int) {return nil}
    }
    
    public struct SimpleOrder: Decodable {
       public struct Content: Decodable {
            let date: String
            let type: String
            let rate: String
            let amount: String
            let startingAmount: String
            let total: String
            let orderNumber: String
            let margin: Int16
        }
        let pairName: String
        let content: [Content]
    }
    
    public struct Pair: Decodable {
        struct Content: Decodable {
            let id:Int64
            let percentChange:String
            let isFrozen:String
        }
        let pairName: String
        let content: Content
    }
    
    public struct Address: Decodable {
        let name: String
        var address: String
    }
    
    
    public struct Currency: Decodable, Comparable {
        public static func < (lhs: EntryList.Currency, rhs: EntryList.Currency) -> Bool {
            let a = (Double(lhs.content.btcValue) ?? 0.00000000) - (Double(rhs.content.btcValue) ?? 0.00000000)
            return a > 0.00000001
            
        }
        
        public static func == (lhs: EntryList.Currency, rhs: EntryList.Currency) -> Bool {
            return lhs.name == rhs.name
        }
        
        struct Content: Decodable {
            let available: String
            let onOrders: String
            let btcValue: String
        }
        let name: String
        let content: Content
        var address: String?
    }
    
    let pairs: [Pair]
    var wallet: [Currency]
    var addresses: [Address]
    let orders: [SimpleOrder]
    
    public init(from decoder: Decoder) throws {
        let entriesContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
        do{
            orders = try entriesContainer.allKeys.map { key in
                let content = try entriesContainer.decode([SimpleOrder.Content].self, forKey: key)
                return SimpleOrder(pairName: key.stringValue, content: content)
            }
        }catch{
            orders = []
        }
        do{
            pairs = try entriesContainer.allKeys.map { key in
                let content = try entriesContainer.decode(Pair.Content.self, forKey: key)
                return Pair(pairName: key.stringValue, content: content)
            }
        }catch{
            pairs = []
        }
        do{
            wallet = try entriesContainer.allKeys.map { key in
                let content = try entriesContainer.decode(Currency.Content.self, forKey: key)
                return Currency(name: key.stringValue, content: content, address: nil)
            }
        }catch{
            wallet = []
        }
        do{
            addresses = try entriesContainer.allKeys.map { key in
                let content = try entriesContainer.decode(String.self, forKey: key)
                return Address(name: key.stringValue, address: content)
            }
        }catch{
            addresses = []
        }
        if orders.count > 0 || wallet.count > 0 || (addresses.count > 0 && addresses.first?.name != "error") || pairs.count > 0{
            return
        }
        throw ErrorMessage(error: "Bad decode")
    }
    
    //    init(from decoder: Decoder, flag:String) throws {
    //        let entriesContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
    //
    //        wallet = try entriesContainer.allKeys.map { key in
    //            let content = try entriesContainer.decode(Currency.Content.self, forKey: key)
    //            return Currency(pairName: key.stringValue, content: content)
    //        }
    //    }
}
