//
//  PoloniexApiService.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

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
    let utilsService:NetworkService
    
    init(utilService: NetworkService) {
        self.utilsService = utilService
    }
    
    public func getPairs(completion: @escaping (Result<[EntryList.Pair],ErrorMessage>) -> Void) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/public"
        
        let comand = URLQueryItem(name: "command", value: "returnTicker")
        
        components.queryItems = [comand]
        utilsService.getRequest(url: components.url!) { result in
            
            switch result {
            case .success(let data):
                do {
                    let entryList = try JSONDecoder().decode(EntryList.self, from: data)
                    completion(.success(entryList.pairs))
                } catch {
                    do {
                        let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                        completion(.failure(error))
                    } catch {
                        completion(.failure(ErrorMessage(error: "Decode Error")))                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    public func getChart(pairName: String, start: String, end: String, period: String, completion: @escaping (Result<[Chart],ErrorMessage>) -> Void) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/public"
        
        let command = URLQueryItem(name: "command", value: "returnChartData")
        let currencyPair = URLQueryItem(name: "currencyPair", value: pairName)
        let start = URLQueryItem(name: "start", value: start)
        let end = URLQueryItem(name: "end", value: end)
        let period = URLQueryItem(name: "period", value: period)
        
        components.queryItems = [command, currencyPair, start, end, period]
        utilsService.getRequest(url: components.url!) { result in
            switch result {
            case .success(let data):
                do {
                    let chart = try JSONDecoder().decode([Chart].self, from: data)
                    completion(.success(chart))
                } catch {
                    do {
                        let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                        completion(.failure(error))
                    } catch {
                        completion(.failure(ErrorMessage(error: "Decode Error")))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    public func getWallet(completion: @escaping (Result<[EntryList.Currency],ErrorMessage>) -> Void) {
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
            utilsService.postRequest(url: components.url!, header: headers, body: sign) { result in
                switch result {
                case .success(let data):
                    do {
                        let entryList = try JSONDecoder().decode(EntryList.self, from: data)
                        completion(.success(entryList.wallet))
                    } catch {
                        do {
                            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(.failure(error))
                        } catch {
                            completion(.failure(ErrorMessage(error: "Decode Error")))
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(ErrorMessage(error: error.localizedDescription)))
                }
            }
        }else{
            completion(.failure(ErrorMessage(error: "No api keys")))
        }
    }
    
    public func getWalletAddress(completion: @escaping (Result<[EntryList.Address], ErrorMessage>) -> Void) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/tradingApi"
        
        let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
        let timeNow = String(timeNowInt)
        if key != "" && secret != "" {
            let sign = "command=returnDepositAddresses&nonce=\(timeNow)"
            let hmacSign = sign.hmac(algorithm: .SHA512, key: secret)
            let headers = ["key" : key, "sign" : hmacSign]
            utilsService.postRequest(url: components.url!, header: headers, body: sign) { result in
                switch result {
                case .success(let data):
                    do {
                        let entryList = try JSONDecoder().decode(EntryList.self, from: data)
                        completion(.success(entryList.addresses))
                    } catch {
                        do {
                            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(.failure(error))
                        } catch {
                            completion(.failure(ErrorMessage(error: "Decode Error")))                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(ErrorMessage(error: error.localizedDescription)))
                }
            }
        }else{
            completion(.failure(ErrorMessage(error: "No api keys")))        }
    }
    
    public func getOrders(completion: @escaping (Result<[EntryList.SimpleOrder.Content], ErrorMessage>) -> Void) {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/tradingApi"
        
        let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
        let timeNow = String(timeNowInt)
        if key != "" && secret != "" {
            let sign = "command=returnOpenOrders&currencyPair=all&nonce=\(timeNow)"
            let hmacSign = sign.hmac(algorithm: .SHA512, key: secret)
            let headers = ["key" : key, "sign" : hmacSign]
            utilsService.postRequest(url: components.url!, header: headers, body: sign) { result in
                switch result {
                case .success(let data):
                    do {
                        let entryList = try JSONDecoder().decode(EntryList.self, from: data)
                        completion(.success(entryList.orders.flatMap({ $0.content })))
                    } catch {
                        do {
                            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(.failure(error))
                        } catch {
                            completion(.failure(ErrorMessage(error: "Decode Error")))                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(ErrorMessage(error: error.localizedDescription)))
                }
            }
        }else{
            completion(.failure(ErrorMessage(error: "No api keys")))        }
    }
    
    public func buyOrder(currencyPair: String, rate: String, amount: String, completion: @escaping (Result<Order, ErrorMessage>) -> Void) {
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
            utilsService.postRequest(url: components.url!, header: headers, body: sign) { result in
                switch result {
                case .success(let data):
                    do {
                        let order = try JSONDecoder().decode(Order.self, from: data)
                        completion(.success(order))
                    } catch {
                        do {
                            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(.failure(error))
                        } catch {
                            completion(.failure(ErrorMessage(error: "Decode Error")))                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(ErrorMessage(error: error.localizedDescription)))
                }
            }
        }else{
            completion(.failure(ErrorMessage(error: "No api keys")))        }
    }
    
    public func sellOrder(currencyPair: String, rate: String, amount: String, completion: @escaping (Result<Order,ErrorMessage>) -> Void) {
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
            utilsService.postRequest(url: components.url!, header: headers, body: sign) { result in
                switch result {
                case .success(let data):
                    do {
                        let order = try JSONDecoder().decode(Order.self, from: data)
                        completion(.success(order))
                    } catch {
                        do {
                            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(.failure(error))
                        } catch {
                            completion(.failure(ErrorMessage(error: "Decode Error")))                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(ErrorMessage(error: error.localizedDescription)))
                }
            }
        }else{
            completion(.failure(ErrorMessage(error: "No api keys")))
            
        }
    }
    
    
    public func cancelOrder(orderNumber: String, completion: @escaping (Result<Bool,ErrorMessage>) -> Void){
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = "/tradingApi"
        
        let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
        let timeNow = String(timeNowInt)
        if key != "" && secret != "" {
            let sign = "command=cancelOrder&orderNumber=\(orderNumber)&nonce=\(timeNow)"
            let hmacSign = sign.hmac(algorithm: .SHA512, key: secret)
            let headers = ["key" : key, "sign" : hmacSign]
            utilsService.postRequest(url: components.url!, header: headers, body: sign) { result in
                switch result {
                case .success(let data):
                    do {
                        let order = try JSONDecoder().decode(CancelOrder.self, from: data)
                        completion(.success((order.success == 1) ? true : false))
                    } catch {
                        do {
                            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                            completion(.failure(error))
                        } catch {
                            completion(.failure(ErrorMessage(error: "Decode Error")))                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(ErrorMessage(error: error.localizedDescription)))
                }
            }
        }else{
            completion(.failure(ErrorMessage(error: "No api keys")))
            
        }
    }
}
