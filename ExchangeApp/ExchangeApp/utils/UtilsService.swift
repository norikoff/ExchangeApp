//
//  UtilsService.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

class UtilsService {
    
    func postRequest(url:URL,header:[String:String], body:String, completion: @escaping (Result<Data, NetworkError>) -> Void){
        var request = URLRequest(url: url)
        for item in header{
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError))
                }
                return
            }
            completion(.success(data))
            }.resume()
    }
    
    func getRequest(url:URL,completion: @escaping (Result<Data, NetworkError>) -> Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError))
                }
                return
            }
            completion(.success(data))
            }.resume()
    }
}

