//
//  DaoTest.swift
//  ExchangeAppTests
//
//  Created by Юрий Нориков on 01.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import XCTest
@testable import ExchangeApp


class DaoTest: XCTestCase {
    
    func testWalletDaoSaveGet() {
        let testDao = WalletDao()
        let wallet = """
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
        let wall = try! JSONDecoder().decode(EntryList.self, from: wallet.data(using: .utf8)!)
        var testWallet: EntryList.Currency?
        testDao.clear{_ in}
        let group = DispatchGroup()
        group.enter()
        testDao.save(model: wall.wallet.first! ){ result in
            switch result {
            case .success:
                testDao.get(identifier: wall.wallet.first!.name){ result in
                    switch result {
                    case .success(let data):
                        testWallet = data
                        group.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                        group.leave()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                group.leave()
            }
        }
        group.wait()
        XCTAssert(wall.wallet.first!.name.elementsEqual(testWallet?.name ?? "wrong"))
    }
    
    func testChartDaoSaveGet() {
        let testDao = ChartDao()
        let chart = """
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
        let char = try! JSONDecoder().decode([Chart].self, from: chart.data(using: .utf8)!)
        var testWallet: Chart?
        testDao.clear{_ in}
        let group = DispatchGroup()
        group.enter()
        testDao.save(model: char.first!){ result in
            switch result {
            case .success:
                testDao.get(identifier: char.first!.date){ result in
                    switch result {
                    case .success(let data):
                        testWallet = data
                        group.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                        group.leave()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                group.leave()
            }
        }
        group.wait()
        XCTAssert(char.first!.close == testWallet?.close)
    }
    
    func testPairDaoSaveGet() {
        let testDao = PairDao()
        let pair = """
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
        let pairs = try! JSONDecoder().decode(EntryList.self, from: pair.data(using: .utf8)!)
        var testWallet: EntryList.Pair?
        testDao.clear{_ in}
        let group = DispatchGroup()
        group.enter()
        testDao.save(model: pairs.pairs.first!){ result in
            switch result {
            case .success:
                testDao.get(identifier: pairs.pairs.first!.pairName){ result in
                    switch result {
                    case .success(let data):
                        testWallet = data
                        group.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                        group.leave()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                group.leave()
            }
        }
        group.wait()
        XCTAssert(pairs.pairs.first!.pairName.elementsEqual(testWallet?.pairName ?? "wrong"))
    }
    
    func testOrderDaoSaveGet() {
        let testDao = OrderDao()
        let orderData = """
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
        let order = try! JSONDecoder().decode(Order.self, from: orderData.data(using: .utf8)!)
        var testWallet: Order?
        let group = DispatchGroup()
        group.enter()
        testDao.save(model: order){ result in
            switch result {
            case .success:
                testDao.get(identifier: order.orderNumber){ result in
                    switch result {
                    case .success(let data):
                        testWallet = data
                        group.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                        group.leave()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                group.leave()
            }
        }
        group.wait()
        XCTAssert(order.resultingTrades!.first!.tradeID.elementsEqual(testWallet?.resultingTrades?.first?.tradeID ?? "wrong"))
    }
    
}
