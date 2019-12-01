////
////  OrderDao.swift
////  ExchangeApp
////
////  Created by Юрий Нориков on 30.11.2019.
////  Copyright © 2019 norikoff. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//
//class OrderDao: BaseDao {
//
//    typealias T = Order
//    typealias ID = String
//
//    func getAll(completion: @escaping (Result<[T]?, ErrorMessage>) -> Void) {
//        let stack = CoreDataStack.shared
//
//        stack.persistentContainer.performBackgroundTask { (context) in
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Pair")
//            fetchRequest.returnsObjectsAsFaults = false
//            do{
//                var dtos: [Order]? = []
//                let results = try context.fetch(fetchRequest) as! [Order]
////                for dto in results{
////                    dtos?.append(Order(orderNumber: dto.value(forKey: "pairName") as! String, resultingTrades: <#T##[Order.TradeResult]?#>, fee: dto.value(forKey: "pairName") as! String, clientOrderId: dto.value(forKey: "pairName") as! String, currencyPair: dto.value(forKey: "pairName") as! String))
////                }
//                completion(.success(results))
//            }catch(let error){
//                print(error.localizedDescription)
//                completion(.failure(ErrorMessage(error: error.localizedDescription)))
//            }
//        }
//    }
//
//    func get(identifier: ID, completion: @escaping (Result<T?, ErrorMessage>) -> Void){
////        let stack = CoreDataStack.shared
////
////        stack.persistentContainer.performBackgroundTask { (context) in
////            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "ChartModel")
////            let predicate = NSPredicate(format: "date = %@", identifier)
////            fetchRequest.predicate = predicate
////            fetchRequest.returnsObjectsAsFaults = false
////            do{
////                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
////                guard let dto = results.first else {
////                    completion(.failure(ErrorMessage(error: "can't get")))
////                    return
////                }
////                completion(.success(EntryList.Pair(pairName: dto.value(forKey: "pairName") as! String, content: EntryList.Pair.Content(id: dto.value(forKey: "id") as! Int64, percentChange: dto.value(forKey: "percentChange") as! String, isFrozen: dto.value(forKey: "isFrozen") as! String))))
////            }catch(let error){
////                print(error.localizedDescription)
////                completion(.failure(ErrorMessage(error: error.localizedDescription)))
////            }
////        }
//    }
//
//    func save(model: T, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
//        let stack = CoreDataStack.shared
//        stack.persistentContainer.performBackgroundTask { (context) in
//            let currency = OrderData(context: context)
//            let set = NSMutableSet()
//            set.addObjects(from: model.resultingTrades!)
//            currency.tradeResults = set
//            currency.fee = model.fee
//            currency.currencyPair = model.currencyPair
//            currency.clientOrderId = model.clientOrderId
//            currency.orderNumber = model.orderNumber
//            do {
//                try context.save()
//                completion(.success(true))
//            } catch(let error) {
//                print(error.localizedDescription)
//                completion(.failure(ErrorMessage(error: error.localizedDescription)))
//            }
//        }
//    }
//
//    func saveAll(model: [T], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
////        let stack = CoreDataStack.shared
////        stack.persistentContainer.performBackgroundTask { (context) in
////            for cur in model{
////                let currency = Pair(context: context)
////                currency.id = cur.content.id
////                currency.name = cur.pairName
////                currency.percentChange = cur.content.percentChange
////                currency.isFrozen = cur.content.isFrozen
////            }
////            do {
////                try context.save()
////                completion(.success(true))
////            } catch(let error) {
////                print(error.localizedDescription)
////                completion(.failure(ErrorMessage(error: error.localizedDescription)))
////            }
////        }
//    }
//
//}
