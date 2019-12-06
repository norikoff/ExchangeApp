//
//  MockNetworkService.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 05.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

class MockNetworkService : NetworkService  {
    
    var data: String?
    
    func postRequest(url: URL, header: [String : String], body: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        completion(.success(data!.data(using: .utf8)!))
    }
    
    func getRequest(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        completion(.success(data!.data(using: .utf8)!))
    }
    

}
