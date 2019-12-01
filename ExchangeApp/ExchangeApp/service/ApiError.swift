//
//  ErrorMessage.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 28.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public struct ErrorMessage: Codable, Error {
    let error:String
}

public enum NetworkError: String, Error {
    case domainError = "domainError"
    case decodingError = "decodingError"
    case authError = "authError"
    case operationError = "operationError"
}


