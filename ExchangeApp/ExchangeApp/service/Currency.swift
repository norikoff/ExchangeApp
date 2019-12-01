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
    
    public struct Pair: Decodable {
        struct Content: Decodable {
            let id:Int
            let last:String
            let lowestAsk:String
            let highestBid:String
            let percentChange:String
            let baseVolume:String
            let quoteVolume:String
            let isFrozen:String
            let high24hr:String
            let low24hr:String
            
        }
        let pairName: String
        let content: Content
    }
    
    public struct Address: Decodable {
        let name: String
        let address: String
    }
    
    
    public struct Currency: Decodable {
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
    let addresses: [Address]
    
    public init(from decoder: Decoder) throws {
        let entriesContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
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
