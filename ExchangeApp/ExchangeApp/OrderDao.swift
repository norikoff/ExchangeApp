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
    
    func getAll(completion: @escaping (Result<[Order]?, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
    
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "CurrencyModel")
            let results = try! context.fetch(fetchRequest)
            let res = results as! OrderData
        }
    }
    
    func get(identifier: ID, completion: @escaping (Result<[Order]?, ErrorMessage>) -> Void){
        
    }
    
    func save(model: Order, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            let order = OrderData(context: context)
            let tradeResult = OrderData(context: context)
            try! context.save()
        }
    }
    
    func saveAll(model: [Order], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        
    }
    
}
