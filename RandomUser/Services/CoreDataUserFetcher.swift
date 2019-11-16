//
//  CoreDataUserFetcher.swift
//  RandomUser
//
//  Created by Haoming Ma on 16/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import CoreData

class CoreDataUserFetcher {
    private weak var managedObjectContext: NSManagedObjectContext!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<UserEntity> = {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest() as! NSFetchRequest<UserEntity>

        fetchRequest.fetchBatchSize = 30
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: self.managedObjectContext,
                                          sectionNameKeyPath: nil, cacheName: "UserCoreDataCache")
    }()
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func fetch() -> [UserEntity] {
        do {
            try self.fetchedResultsController.performFetch()
            return self.fetchedResultsController.fetchedObjects!
        } catch {
            print("performFetch error: \(error)")
            return []
        }
    }
}
