//
//  ChartDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 27.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CoreData


class ChartDao: BaseDao {
    
    typealias T = Chart
    typealias ID = Int64
    
    func clear(completion: @escaping (Result<Bool, ErrorMessage>) -> Void){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ChartModel")
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
    
    func getAll(completion: @escaping (Result<[T]?, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        
        stack.persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "ChartModel")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                var dtos: [Chart]? = []
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                for dto in results{
                    dtos?.append(Chart(date: dto.value(forKey: "date") as! Int64, high: dto.value(forKey: "high") as! Double, low: dto.value(forKey: "low") as! Double, open: dto.value(forKey: "open") as! Double, close: dto.value(forKey: "close") as! Double, volume: dto.value(forKey: "volume") as! Double, quoteVolume: dto.value(forKey: "quoteVolume") as! Double, weightedAverage: dto.value(forKey: "weightedAverage") as! Double))
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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "ChartModel")
            let predicate = NSPredicate(format: "date == %@", "\(identifier)")
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                guard let dto = results.first else {
                    completion(.failure(ErrorMessage(error: "can't get")))
                    return
                }
                completion(.success(Chart(date: dto.value(forKey: "date") as! Int64, high: dto.value(forKey: "high") as! Double, low: dto.value(forKey: "low") as! Double, open: dto.value(forKey: "open") as! Double, close: dto.value(forKey: "close") as! Double, volume: dto.value(forKey: "volume") as! Double, quoteVolume: dto.value(forKey: "quoteVolume") as! Double, weightedAverage: dto.value(forKey: "weightedAverage") as! Double)))
            }catch(let error){
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func save(model: Chart, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            let currency = ChartModel(context: context)
            currency.date = model.date
            currency.high = model.high
            currency.low = model.low
            currency.open = model.open
            currency.close = model.close
            currency.quoteVolume = model.quoteVolume
            currency.weightedAverage = model.weightedAverage
            currency.volume = model.volume
            do {
                try context.save()
                completion(.success(true))
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(ErrorMessage(error: error.localizedDescription)))
            }
        }
    }
    
    func saveAll(model: [Chart], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let stack = CoreDataStack.shared
        stack.persistentContainer.performBackgroundTask { (context) in
            for cur in model{
                let currency = ChartModel(context: context)
                currency.date = cur.date
                currency.high = cur.high
                currency.low = cur.low
                currency.open = cur.open
                currency.close = cur.close
                currency.quoteVolume = cur.quoteVolume
                currency.weightedAverage = cur.weightedAverage
                currency.volume = cur.volume
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
