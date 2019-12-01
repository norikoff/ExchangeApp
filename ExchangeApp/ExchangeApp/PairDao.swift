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
    typealias ID = Int
    
    func getAll(completion: @escaping (Result<[EntryList.Pair]?, ErrorMessage>) -> Void) {
        
    }
    
    func get(identifier: ID, completion: @escaping (Result<[EntryList.Pair]?, ErrorMessage>) -> Void){
        
    }
    
    func save(model: EntryList.Pair, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        
    }
    
    func saveAll(model: [EntryList.Pair], completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        
    }

}
