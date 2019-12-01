//
//  DaoTest.swift
//  ExchangeAppTests
//
//  Created by Юрий Нориков on 01.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import XCTest

class DaoTest: XCTestCase {
    let testDao = WalletDao()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWalletDao() {
        let wallet = EntryList.Currency(name: "BTC", content: EntryList.Currency.Content(available: "0.0", onOrders: "0.0", btcValue: "0.0"), address: "address")
        var testWallet: EntryList.Currency?
        let group = DispatchGroup()
        group.enter()
        testDao.save(model: wallet){ result in
            switch result {
            case .success(let data):
                print(data)
                self.testDao.getAll(){ result in
                    switch result {
                    case .success(let data):
                        print(data)
                        testWallet = data?.first
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
        XCTAssert(wallet.name.elementsEqual(testWallet?.name ?? "wrong"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
