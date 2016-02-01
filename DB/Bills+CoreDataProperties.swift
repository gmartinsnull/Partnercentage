//
//  Bills+CoreDataProperties.swift
//  Partnercentage
//
//  Created by Glauber Martins on 2016-01-30.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bills {

    @NSManaged var name: String?
    @NSManaged var value: NSNumber?
    @NSManaged var tax: NSNumber?

}
