//
//  WalletDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 26.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CoreData


public class WalletDao: BaseDao {
    
    typealias T = EntryList.Currency
    typealias ID = String
    
    func getAll(completion: @escaping (Result<[T]?, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WalletCurrency")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest) as! [WalletCurrency]
                var dtos: [EntryList.Currency]?
                for dto in results{
                    dtos?.append(EntryList.Currency(name: dto.name!, content: EntryList.Currency.Content(available: dto.available!, onOrders: dto.onOrders!, btcValue: dto.btcValue!), address: dto.address!))
                }
                completion(.success(dtos))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func get(identifier: ID, completion: @escaping (Result<[T]?, ErrorMessage>) -> Void){
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WalletCurrency")
            let predicate = NSPredicate(format: "name = %@", identifier)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest) as! [EntryList.Currency]
                completion(.success(results))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func save(model: EntryList.Currency, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            let currency = WalletCurrency(context: context)
            currency.name = model.name
            currency.available = model.content.available
            currency.btcValue = model.content.btcValue
            currency.onOrders = model.content.onOrders
            currency.address = model.address
            do {
                try context.save()
                completion(.success(true))
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func saveAll(model: [EntryList.Currency], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            for cur in model{
                let currency = WalletCurrency(context: context)
                currency.name = cur.name
                currency.available = cur.content.available
                currency.btcValue = cur.content.btcValue
                currency.onOrders = cur.content.onOrders
                currency.address = cur.address
            }
            do {
                try context.save()
                completion(.success(true))
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
}
