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
    typealias ID = Int
    
    func getAll(completion: @escaping (Result<[T]?, ErrorMessage>) -> Void) {
        
    }
    
    func get(identifier: ID, completion: @escaping (Result<[T]?, ErrorMessage>) -> Void){
        
    }
    
    func save(model: Chart, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        
    }
    
    func saveAll(model: [Chart], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        
    }
    
}
