//
//  Chart.swift
//  ApiExchangeService
//
//  Created by Юрий Нориков on 17.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

struct Chart: Codable {
    let date: Int
    let high: Double
    let low: Double
    let open: Double
    let close: Double
    let volume: Double
    let quoteVolume: Double
    let weightedAverage: Double
}
