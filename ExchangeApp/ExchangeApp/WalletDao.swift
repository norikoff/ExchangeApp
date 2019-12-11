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
    
    func clear(completion: @escaping (Result<Bool, ErrorMessage>) -> Void){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WalletCurrency")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
    }
    
    func getAll(param: Any?, completion: @escaping (Result<[T]?, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WalletCurrency")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                var dtos: [EntryList.Currency]? = []
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                for dto in results{
                    dtos?.append(EntryList.Currency(name: dto.value(forKey: "name") as! String, content: EntryList.Currency.Content(available: dto.value(forKey: "available") as! String, onOrders: dto.value(forKey: "onOrders") as! String, btcValue: dto.value(forKey: "btcValue") as! String), address: dto.value(forKey: "address") as? String))
                }
                completion(.success(dtos))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func get(identifier: ID, completion: @escaping (Result<T?, ErrorMessage>) -> Void){
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WalletCurrency")
            let predicate = NSPredicate(format: "name = %@", identifier)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                guard let dto = results.first else {
                    completion(.failure(ErrorMessage(error: "can't get")))
                    return
                }
                completion(.success(EntryList.Currency(name: dto.value(forKey: "name") as! String, content: EntryList.Currency.Content(available: dto.value(forKey: "available") as! String, onOrders: dto.value(forKey: "onOrders") as! String, btcValue: dto.value(forKey: "btcValue") as! String), address: dto.value(forKey: "address") as? String)))
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
