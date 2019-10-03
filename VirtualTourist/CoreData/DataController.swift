//
//  DataController.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
