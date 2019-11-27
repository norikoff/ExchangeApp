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
    
    var poloniexService = PoloniexApiService()
    let api = ""
    let secret = ""
    
    override func setUp() {
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
        poloniexService.getPairs { (data, error) in
            pairs = data
            group.leave()
        }
        group.wait()
        XCTAssert(pairs.count>0)
    }
    
    func testChart() {
        let group = DispatchGroup()
        group.enter()
        var charts:[Chart] = []
        poloniexService.getChart(pairName: "USDT_ETH", start: String(Int(NSDate().timeIntervalSince1970)-1000), end: String(Int(NSDate().timeIntervalSince1970)), period: String(300)){(data, error) in
            charts = data
            group.leave()
        }
        group.wait()
        XCTAssert(charts.count>0)
    }
    
    func testBalance() {
        let group = DispatchGroup()
        group.enter()
        var wallet:[EntryList.Currency] = []
        poloniexService.getWallet { (data, error) in
            wallet = data
            group.leave()
        }
        group.wait()
        XCTAssert(wallet.count>0)
    }
    
        func testBuy() {
            poloniexService.buyOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100")
        }
    
        func testSell() {
            poloniexService.sellOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100")
        }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
