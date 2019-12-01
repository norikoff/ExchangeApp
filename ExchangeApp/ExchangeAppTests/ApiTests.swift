//
//  ExchangeAppTests.swift
//  ExchangeAppTests
//
//  Created by Юрий Нориков on 17.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import XCTest
@testable import ExchangeApp

class ExchangeAppTests: XCTestCase {
    
    var poloniexService: ApiService?
    let api = "S439VAVT-H45BUYTI-KLEM0AAG-8EK7PXU8"
    let secret = "532ae5f8d1e2ade9861a22a22ca50392fe306699d1499e42d28d4ccaf9034c37f0ad910a0aa39f42eaa8b333d8382a54f9f15036f838093539b61ccde2e24f9f"
    
    override func setUp() {
        let utilsService = UtilsService()
        poloniexService = PoloniexApiService(utilService: utilsService)
        UserDefaults.standard.set(api, forKey: "key")
        UserDefaults.standard.set(secret, forKey: "secret")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPairs() {
        let group = DispatchGroup()
        group.enter()
        var pairs:[EntryList.Pair] = []
        poloniexService!.getPairs { result in
            switch result {
            case .success(let pair):
                pairs = pair
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
        XCTAssert(pairs.count>0)
    }
    
    func testChart() {
        let group = DispatchGroup()
        group.enter()
        var charts:[Chart] = []
        poloniexService!.getChart(pairName: "USDT_ETH", start: String(Int(NSDate().timeIntervalSince1970)-1000), end: String(Int(NSDate().timeIntervalSince1970)), period: String(300)){ result in
            switch result {
            case .success(let chart):
                charts = chart
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
        XCTAssert(charts.count>0)
    }
    
    func testWallet() {
        let group = DispatchGroup()
        group.enter()
        var wallet:[EntryList.Currency] = []
        poloniexService!.getWallet { result in
            switch result {
            case .success(let cur):
                wallet = cur
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
        XCTAssert(wallet.count>0)
    }
    
    func testWalletAddresses() {
        let group = DispatchGroup()
        group.enter()
        var wallet:[EntryList.Address] = []
        poloniexService!.getWalletAddress { result in
            switch result {
            case .success(let cur):
                wallet = cur
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
        XCTAssert(wallet.count>0)
    }
    
    func testBuy() {
        let group = DispatchGroup()
        group.enter()
        poloniexService!.buyOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100"){ result in
            switch result {
            case .success(let order):
                print(order)
                group.leave()
            case .failure(let error):
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
    }
    
    func testSell() {
        let group = DispatchGroup()
        group.enter()
        poloniexService!.sellOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100"){ result in
            switch result {
            case .success(let order):
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
    
}
