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
    let api = "8MJW176X-0DIR51FU-WCPMI4DW-XLBDPCJO"
    let secret = "53f1c8b8776a3e9efe1a10c2f1cb8a4bc1139639709600c72cc5498e20ee216d66c97ec8a4d4d847be21bfa729eb1b9f4b5fbfcc480e83a498e37da0a1bc1b3e"

    override func setUp() {
        UserDefaults.standard.set(api, forKey: "key")
        UserDefaults.standard.set(secret, forKey: "secret")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPairs() {
        poloniexService.getPairs()
        sleep(1)
    }
    
    func testChart() {
        poloniexService.getChart(pairName: "USDT_ETH", start: String(Int(NSDate().timeIntervalSince1970)-1000), end: String(Int(NSDate().timeIntervalSince1970)), period: String(300))
        sleep(1)
    }
    
    func testBalance() {
        poloniexService.getWallet()
        sleep(1)
    }
    
    func testBuy() {
        poloniexService.buyOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100")
        sleep(1)
    }
    
    func testSell() {
        poloniexService.sellOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100")
        sleep(1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
