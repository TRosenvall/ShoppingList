//
//  Item+Convenience.swift
//  Shopping List
//
//  Created by Timothy Rosenvall on 6/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    @discardableResult
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.managedObjectContext ) {
        self.init(context: context)
        self.name = name
    }
}
