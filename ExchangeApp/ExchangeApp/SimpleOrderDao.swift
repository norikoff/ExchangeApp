//
//  SimpleOrderDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 03.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CoreData


class SimpleOrderDao: BaseDao {
    
    typealias T = SimpleOrder
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
    
    func getAll(completion: @escaping (Result<[SimpleOrder]?, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "SimpleOrderModel")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                var dtos: [SimpleOrder] = []
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                for dto in results{
                    dtos.append(SimpleOrder(globalTradeID: dto.value(forKey: "globalTradeID") as! Int64, tradeID: dto.value(forKey: "tradeID") as! Int64, date: dto.value(forKey: "date") as! String, type: dto.value(forKey: "type") as! String, rate: dto.value(forKey: "rate") as! String, amount: dto.value(forKey: "amount") as! String, total: dto.value(forKey: "total") as! String, orderNumber: dto.value(forKey: "orderNumber") as! String))
                }
                completion(.success(dtos))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func get(identifier: String, completion: @escaping (Result<SimpleOrder?, ErrorMessage>) -> Void) {
        //don't use
    }
    
    func save(model: SimpleOrder, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        //don't use
    }
    
    func saveAll(model: [SimpleOrder], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            for ord in model{
                let currency = SimpleOrderModel(context: context)
                currency.orderNumber = ord.orderNumber
                currency.globalTradeID = ord.globalTradeID
                currency.tradeID = ord.tradeID
                currency.date = ord.date
                currency.type = ord.type
                currency.rate = ord.rate
                currency.amount = ord.amount
                currency.total = ord.total
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
