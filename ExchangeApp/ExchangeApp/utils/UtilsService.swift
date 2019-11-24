//
//  UtilsService.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

class UtilsService {
    
    func postRequest(url:URL,header:[String:String], body:String, completion: @escaping (Data?, Error?) -> Void){
        var request = URLRequest(url: url)
        for item in header{
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let currentData = data else { return }
            completion(currentData,nil)
        }
        task.resume()
    }
    
    func getRequest(url:URL,completion: @escaping (Data?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let currentData = data else { return }
            completion(currentData,nil)
        }
        task.resume()
    }
}

