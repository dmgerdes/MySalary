//
//  SalesEntry+CoreDataProperties.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/20/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import Foundation
import CoreData


extension SalesEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SalesEntry> {
        return NSFetchRequest<SalesEntry>(entityName: "SalesEntry")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var sales: Double
    @NSManaged public var salary: Salary?

}
