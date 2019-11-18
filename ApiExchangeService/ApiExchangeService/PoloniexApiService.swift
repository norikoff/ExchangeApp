//
//  PoloniexApiService.swift
//  ApiExchangeService
//
//  Created by Юрий Нориков on 16.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CommonCrypto

public class PoloniexApiService: ApiService {
    
    var key: String {
        if UserDefaults.standard.value(forKey: "key") != nil {
            return UserDefaults.standard.value(forKey: "key") as! String
        } else {
            print("there is no key")
            return ""
        }
    }
    
    var secret: String {
        if UserDefaults.standard.value(forKey: "secret") != nil {
            return UserDefaults.standard.value(forKey: "secret") as! String
        } else {
            print("there is no secret")
            return ""
        }
    }
    
    //https://poloniex.com/public?command=returnTicker
    let baseScheme = "https"
    let baseHost = "poloniex.com"
    let utilsService = UtilsService()
    
    public func getPairs() {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/public"
        
        let comand = URLQueryItem(name: "command", value: "returnTicker")
        
        components.queryItems = [comand]
        
        utilsService.makeGetRequest(url: components.url!) { (data, error) in
            let dataString = String(data: data!, encoding: .utf8)
            let entryList = try! JSONDecoder().decode(EntryList.self, from: dataString!.data(using: .utf8)!)
            for pair in entryList.pairs{
                print("\(pair.pairName)-\(pair.content.id)-\(pair.content.isFrozen)")
            }
        }
    }
    
    public func getChart(pairName: String, start: String, end: String, period: String) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/public"
        
        let command = URLQueryItem(name: "command", value: "returnChartData")
        let currencyPair = URLQueryItem(name: "currencyPair", value: pairName)
        let start = URLQueryItem(name: "start", value: start)
        let end = URLQueryItem(name: "end", value: end)
        let period = URLQueryItem(name: "period", value: "300")
        
        components.queryItems = [command, currencyPair, start, end, period]
        
        utilsService.makeGetRequest(url: components.url!) { (data, error) in
            let entryList = try! JSONDecoder().decode([Chart].self, from: data!)
            for curr in entryList{
                print("\(curr.date)-\(curr.open)")
            }
        }
    }
    
    public func getWallet() {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/tradingApi"
        
        let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
        let timeNow = String(timeNowInt)
        
        if key != "" && secret != "" {
            let sign = "command=returnCompleteBalances&nonce=\(timeNow)"
            let hmacSign = sign.hmac(algorithm: .SHA512, key: secret)
            let headers = ["key" : key, "sign" : hmacSign]
            utilsService.makePostRequest(url: components.url!, header: headers, body: sign) { (data, error) in
                let entryList = try! JSONDecoder().decode(EntryList.self, from: data!)
                for curr in entryList.wallet{
                    print("\(curr.name)-\(curr.content.available)")
                }
            }
        }
    }
    
    public func buyOrder(currencyPair: String, rate: String, amount: String) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/tradingApi"
        
        let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
        let timeNow = String(timeNowInt)
        
        if key != "" && secret != "" {
            let sign = "command=buy&currencyPair=\(currencyPair)&rate=\(rate)&amount=\(amount)&nonce=\(timeNow)"
            let hmacSign = sign.hmac(algorithm: .SHA512, key: secret)
            let headers = ["key" : key, "sign" : hmacSign]
            utilsService.makePostRequest(url: components.url!, header: headers, body: sign) { (data, error) in
                let dataString = String(data: data!, encoding: .utf8)
                print(dataString!)
            }
        }
    }
    
    public func sellOrder(currencyPair: String, rate: String, amount: String) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/tradingApi"
        
        let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
        let timeNow = String(timeNowInt)
        
        if key != "" && secret != "" {
            let sign = "command=sell&currencyPair=\(currencyPair)&rate=\(rate)&amount=\(amount)&nonce=\(timeNow)"
            let hmacSign = sign.hmac(algorithm: .SHA512, key: secret)
            let headers = ["key" : key, "sign" : hmacSign]
            utilsService.makePostRequest(url: components.url!, header: headers, body: sign) { (data, error) in
                let dataString = String(data: data!, encoding: .utf8)
                print(dataString!)
            }
        }
    }
}
