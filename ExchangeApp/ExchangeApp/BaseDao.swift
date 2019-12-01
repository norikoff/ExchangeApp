//
//  BaseDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 27.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

protocol BaseDao {
    
    associatedtype T
    associatedtype ID
    
    /// Fetch all data from table
    ///
    /// - Parameter completionHandler: return array of data or error
    /// - Returns: error
    func getAll(completion: @escaping (Result<[T]?, ErrorMessage>) -> Void)
    
    /// Fetch data from table by id
    ///
    /// - Parameters:
    ///   - identifier: fetch id
    ///   - completion: return array of data or error
    /// - Returns: error
    func get(identifier: ID, completion: @escaping (Result<[T]?, ErrorMessage>) -> Void )
    
    
    /// Create table row
    ///
    /// - Parameters:
    ///   - model: entity for save
    ///   - completion: return bool or error
    /// - Returns: error
    func save(model:T, completion: @escaping (Result<Bool, ErrorMessage>) -> Void)
    
    func saveAll(model: [T], completion: @escaping (Result<Bool, ErrorMessage>) -> Void)
    
    //    func update( model:T ) -> Bool
    //    func delete( model:T ) -> Bool
}
