//
//  OrderDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 30.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CoreData


class OrderDao: BaseDao {
    
    typealias T = Order
    typealias ID = String
    
    func clear(completion: @escaping (Result<Bool, ErrorMessage>) -> Void){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SimpleOrderModel")
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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "OrderData")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                var dtos: [Order]? = []
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                
                for dto in results{
                    var tradeRes: [Order.TradeResult] = []
                    for res in dto.value(forKey: "tradeResults") as! NSSet {
                        let resTrade = res as! NSManagedObject
                        tradeRes.append(Order.TradeResult(amount: resTrade.value(forKey: "amount") as! String, date: resTrade.value(forKey: "date") as! String, rate: resTrade.value(forKey: "rate") as! String, total: resTrade.value(forKey: "total") as! String, tradeID: resTrade.value(forKey: "tradeID") as! String, type: resTrade.value(forKey: "type") as! String))
                    }
                    dtos?.append(Order(orderNumber: dto.value(forKey: "orderNumber") as! String, resultingTrades: tradeRes, fee: dto.value(forKey: "fee") as! String, currencyPair: dto.value(forKey: "currencyPair") as! String))
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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "OrderData")
            let predicate = NSPredicate(format: "orderNumber = %@", identifier)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                guard let dto = results.first else {
                    completion(.failure(ErrorMessage(error: "can't get")))
                    return
                }
                var tradeRes: [Order.TradeResult] = []
                for res in dto.value(forKey: "tradeResults") as! NSSet {
                    let resTrade = res as! NSManagedObject
                    tradeRes.append(Order.TradeResult(amount: resTrade.value(forKey: "amount") as! String, date: resTrade.value(forKey: "date") as! String, rate: resTrade.value(forKey: "rate") as! String, total: resTrade.value(forKey: "total") as! String, tradeID: resTrade.value(forKey: "tradeID") as! String, type: resTrade.value(forKey: "type") as! String))
                }
                completion(.success(Order(orderNumber: dto.value(forKey: "orderNumber") as! String, resultingTrades: tradeRes, fee: dto.value(forKey: "fee") as! String, currencyPair: dto.value(forKey: "currencyPair") as! String)))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func save(model: T, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            let currency = OrderData(context: context)
            let set = NSMutableSet()
            for res in model.resultingTrades ?? []{
                let tradeRes = TradeResult(context: context)
                tradeRes.amount = res.amount
                tradeRes.date = res.date
                tradeRes.rate = res.rate
                tradeRes.total = res.total
                tradeRes.tradeID = res.tradeID
                tradeRes.type = res.type
                tradeRes.order = currency
                set.add(tradeRes)
            }
            currency.fee = model.fee
            currency.currencyPair = model.currencyPair
            currency.orderNumber = model.orderNumber
            currency.tradeResults = set
            do {
                try context.save()
                completion(.success(true))
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func saveAll(model: [T], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            for ord in model{
                let currency = OrderData(context: context)
                let set = NSMutableSet()
                for res in ord.resultingTrades ?? []{
                    let tradeRes = TradeResult(context: context)
                    tradeRes.amount = res.amount
                    tradeRes.date = res.date
                    tradeRes.rate = res.rate
                    tradeRes.total = res.total
                    tradeRes.tradeID = res.tradeID
                    tradeRes.type = res.type
                    tradeRes.order = currency
                    set.add(tradeRes)
                }
                currency.fee = ord.fee
                currency.currencyPair = ord.currencyPair
                currency.orderNumber = ord.orderNumber
                currency.tradeResults = set
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
