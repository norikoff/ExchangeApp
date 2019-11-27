//
//  WalletDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 26.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation


class Walletdao {
    
    func saveWalletCurrency(wallet:EntryList.Currency) {
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let currency = CurrencyModel(context: context)
            currency.id = wallet.name
            try! context.save()
        }
    }
}
