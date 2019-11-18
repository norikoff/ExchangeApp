//
//  Pair.swift
//  ApiExchangeService
//
//  Created by Юрий Нориков on 17.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

struct EntryList: Decodable {
    
    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {self.stringValue = stringValue}
        
        var intValue: Int?{return nil}
        init?(intValue: Int) {return nil}
    }
    
    struct Pair: Decodable {
        struct Content: Decodable {
            let id: Int
            let last: String
            let isFrozen: String
            
        }
        let pairName: String
        let content: Content
    }
    
    struct Currency: Decodable {
        struct Content: Decodable {
            let available: String
            let onOrders: String
            let btcValue: String
        }
        let name: String
        let content: Content
    }
    
    let pairs: [Pair]
    let wallet: [Currency]
    
    init(from decoder: Decoder) throws {
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
                return Currency(name: key.stringValue, content: content)
            }
        }catch{
            wallet = []
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
