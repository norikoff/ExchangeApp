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
    let utilsService = MockNetworkService()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPairsRequest() {
        utilsService.data = """
        { "BTC_BCN":
        { "id": 7,
        "last": "0.00000024",
        "lowestAsk": "0.00000025",
        "highestBid": "0.00000024",
        "percentChange": "0.04347826",
        "baseVolume": "58.19056621",
        "quoteVolume": "245399098.35236773",
        "isFrozen": "0",
        "high24hr": "0.00000025",
        "low24hr": "0.00000022" }}
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
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
        XCTAssert(pairs.first?.pairName == "BTC_BCN")
    }
    
    func testChartRequest() {
        
        utilsService.data = """
        [ { "date": 1539864000,
        "high": 0.03149999,
        "low": 0.031,
        "open": 0.03144307,
        "close": 0.03124064,
        "volume": 64.36480422,
        "quoteVolume": 2055.56810329,
        "weightedAverage": 0.03131241 },
        { "date": 1539878400,
        "high": 0.03129379,
        "low": 0.03095999,
        "open": 0.03124064,
        "close": 0.03108499,
        "volume": 50.21821153,
        "quoteVolume": 1615.31999527,
        "weightedAverage": 0.0310887 }]
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
        
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
        XCTAssert((charts.filter{ $0.date == 1539878400 }.first != nil) && charts.count == 2)
    }
    
    func testWalletRequest() {
        
        utilsService.data = """
        { "1CR":
        { "available": "0.00000000",
        "onOrders": "0.00000000",
        "btcValue": "0.00000000" },
        "ABY":
        { "available": "0.00000000",
        "onOrders": "0.00000000",
        "btcValue": "0.00000000" },
        "AC":
        { "available": "0.00000000",
        "onOrders": "0.00000000",
        "btcValue": "0.00000000" }}
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
        
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
        XCTAssert((wallet.filter{ $0.name == "1CR" }.first != nil) && wallet.count == 3)
    }
    
    func testWalletAddressesRequest() {
        
        utilsService.data = """
        { "BCH": "1FhCkdKeMGa621mCpAtFYzeVfUBnHbooLj",
        "BTC": "131rdg5Rzn6BFufnnQaHhVa5ZtRU1J2EZR",
        "XMR": "4JUdGzvrMFDWrUUwY3toJATSeNwjn54LkCnKBPRzDuhzi5vSepHfUckJNxRL2gjkNrSqtCoRUrEDAgRwsQvVCjZbRxGLC7uLNMGQ693YeY",
        "ZEC": "t1MHktAs4DMjMWqKiji4czLYD1rGNczGeFV" }
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
        
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
        XCTAssert((wallet.filter{ $0.name == "BCH" }.first != nil) && wallet.count == 4)
    }
    
    func testSimpleOrderRequest() {
        
        utilsService.data = """
        [ {"globalTradeID": 394700861,
        "tradeID": 45210354,
        "date": "2018-10-23 18:01:58",
        "type": "buy",
        "rate": "0.03117266",
        "amount": "0.00000652",
        "total": "0.00000020",
        "orderNumber": "104768235093" },
        {"globalTradeID": 394700815,
        "tradeID": 45210353,
        "date": "2018-10-23 18:01:08",
        "type": "buy",
        "rate": "0.03116000",
        "amount": "5.93292717",
        "total": "0.18487001",
        "orderNumber": "104768235092" }]
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
        
        let group = DispatchGroup()
        group.enter()
        var wallet:[SimpleOrder] = []
        poloniexService!.getOrders { result in
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
    
    func testBuyRequest() {
        
        utilsService.data = """
        { "orderNumber": "514845991795",
        "resultingTrades":
        [ { "amount": "3.0",
        "date": "2018-10-25 23:03:21",
        "rate": "0.0002",
        "total": "0.0006",
        "tradeID": "251834",
        "type": "buy" } ],
        "fee": "0.01000000",
        "clientOrderId": "12345",
        "currencyPair": "BTC_ETH" }
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
        var orderData: Order?
        let group = DispatchGroup()
        group.enter()
        poloniexService!.buyOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100"){ result in
            switch result {
            case .success(let order):
                orderData = order
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
        XCTAssert(orderData?.orderNumber == "514845991795")
    }
    
    func testSellRequest() {
        
        utilsService.data = """
        { "orderNumber": "514845991795",
        "resultingTrades":
        [ { "amount": "3.0",
        "date": "2018-10-25 23:03:21",
        "rate": "0.0002",
        "total": "0.0006",
        "tradeID": "251834",
        "type": "sell" } ],
        "fee": "0.01000000",
        "clientOrderId": "12345",
        "currencyPair": "BTC_ETH" }
        """
        poloniexService = PoloniexApiService(utilService: utilsService)
        var orderData: Order?
        let group = DispatchGroup()
        group.enter()
        poloniexService!.sellOrder(currencyPair: "USDT_ETH", rate: "0.0001", amount: "100"){ result in
            switch result {
            case .success(let order):
                orderData = order
                group.leave()
            case .failure:
                print("FAILED")
                group.leave()
            }
        }
        group.wait()
        XCTAssert(orderData?.orderNumber == "514845991795")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
    
}
