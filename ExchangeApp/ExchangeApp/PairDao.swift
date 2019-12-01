//
//  PairDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 27.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CoreData

class PairDao: BaseDao {
       
    typealias T = EntryList.Pair
    typealias ID = String
    
    func getAll(completion: @escaping (Result<[T]?, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Pair")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                var dtos: [EntryList.Pair]? = []
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                for dto in results{
                    dtos?.append(EntryList.Pair(pairName: dto.value(forKey: "name") as! String, content: EntryList.Pair.Content(id: dto.value(forKey: "id") as! Int64, percentChange: dto.value(forKey: "percentChange") as! String, isFrozen: dto.value(forKey: "isFrozen") as! String)))
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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Pair")
            let predicate = NSPredicate(format: "name = %@", identifier)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                guard let dto = results.first else {
                    completion(.failure(ErrorMessage(error: "can't get")))
                    return
                }
                completion(.success(EntryList.Pair(pairName: dto.value(forKey: "name") as! String, content: EntryList.Pair.Content(id: dto.value(forKey: "id") as! Int64, percentChange: dto.value(forKey: "percentChange") as! String, isFrozen: dto.value(forKey: "isFrozen") as! String))))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func save(model: T, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            let currency = Pair(context: context)
            currency.name = model.pairName
            currency.percentChange = model.content.percentChange
            currency.isFrozen = model.content.isFrozen
            currency.id = model.content.id
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
            for cur in model{
                let currency = Pair(context: context)
                currency.id = cur.content.id
                currency.name = cur.pairName
                currency.percentChange = cur.content.percentChange
                currency.isFrozen = cur.content.isFrozen
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
