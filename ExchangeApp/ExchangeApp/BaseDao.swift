//
//  BaseDao.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 27.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation

protocol BaseDao<ID,T> {
    func save(model: T) -> Bool
}
