//
//  CoreDataStack.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 26.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import Foundation
import CoreData

internal final class CoreDataStack {
    
    static let shared: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        return coreDataStack
    }()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        let group = DispatchGroup()
        persistentContainer = NSPersistentContainer(name: "Model")
        group.enter()
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
    
    
}
