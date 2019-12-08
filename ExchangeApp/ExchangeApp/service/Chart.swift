//
//  Chart.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 24.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

public struct Chart: Codable {
    let date: Int64
    let high: Double
    let low: Double
    let open: Double
    let close: Double
    let volume: Double
    let quoteVolume: Double
    let weightedAverage: Double
}
