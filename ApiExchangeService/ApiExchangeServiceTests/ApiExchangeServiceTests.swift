//
//  ApiExchangeServiceTests.swift
//  ApiExchangeServiceTests
//
//  Created by Юрий Нориков on 16.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import XCTest
@testable import ApiExchangeService

class ApiExchangeServiceTests: XCTestCase {
    
    var poloniexService = PoloniexApiService()
    let api = ""
    let secret = ""
    
    override func setUp() {
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
        poloniexService.getChart(pairName: "USDT_ETH", start: String(1574090571), end: String(Int(NSDate().timeIntervalSince1970)), period: String(300))
        sleep(1)
    }
    
    func testBalance() {
        UserDefaults.standard.set(api, forKey: "key")
        UserDefaults.standard.set(secret, forKey: "secret")
        poloniexService.getWallet()
        sleep(1)
    }
    
    func testBuy() {
        UserDefaults.standard.set(api, forKey: "key")
        UserDefaults.standard.set(secret, forKey: "secret")
        poloniexService.buyOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100")
        sleep(1)
    }
    
    func testSell() {
        UserDefaults.standard.set(api, forKey: "key")
        UserDefaults.standard.set(secret, forKey: "secret")
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
