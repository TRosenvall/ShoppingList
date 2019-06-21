//
//  ItemController.swift
//  Shopping List
//
//  Created by Timothy Rosenvall on 6/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    static let sharedInstance = ItemController()
    
    var fetchedResultsController = NSFetchedResultsController<Item>()
    
    init() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let resultsController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Everything is burning down! There fetch results are broken!!!: \(error.localizedDescription)")
        }
    }
    
    // Mark: - CRUD Functions
    // Create
    func createItem(name: String) {
        Item(name: name)
        saveToPersistentStore()
    }
    
    // Read
    func saveToPersistentStore() {
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch {
            print("Everything is exploding! The save function doesn't work!!!: \(error.localizedDescription)")
        }
    }
    
    // Delete
    func deleteItem(item: Item) {
        CoreDataStack.managedObjectContext.delete(item)
        saveToPersistentStore()
    }
    
    func toggleIsCompleteFor (item: Item) {
        item.isComplete = !item.isComplete
        saveToPersistentStore()
    }
}
