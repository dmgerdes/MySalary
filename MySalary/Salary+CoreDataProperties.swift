//
//  Salary+CoreDataProperties.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/20/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import Foundation
import CoreData


extension Salary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Salary> {
        return NSFetchRequest<Salary>(entityName: "Salary")
    }

    @NSManaged public var bonus: Double
    @NSManaged public var goal: Double
    @NSManaged public var isActive: Bool
    @NSManaged public var locAddress: String?
    @NSManaged public var locName: String?
    @NSManaged public var recurrance: String?
    @NSManaged public var salary: Double
    @NSManaged public var updatedDate: NSDate?
    @NSManaged public var salesEntry: NSSet?

}

// MARK: Generated accessors for salesEntry
extension Salary {

    @objc(addSalesEntryObject:)
    @NSManaged public func addToSalesEntry(_ value: SalesEntry)

    @objc(removeSalesEntryObject:)
    @NSManaged public func removeFromSalesEntry(_ value: SalesEntry)

    @objc(addSalesEntry:)
    @NSManaged public func addToSalesEntry(_ values: NSSet)

    @objc(removeSalesEntry:)
    @NSManaged public func removeFromSalesEntry(_ values: NSSet)

}
