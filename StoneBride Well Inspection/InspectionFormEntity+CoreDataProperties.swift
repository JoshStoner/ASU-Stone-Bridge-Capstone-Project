//
//  InspectionFormEntity+CoreDataProperties.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 2/8/21.
//  Copyright © 2021 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension InspectionFormEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InspectionFormEntity> {
        return NSFetchRequest<InspectionFormEntity>(entityName: "InspectionFormEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var inspectionDone: String?
    @NSManaged public var oilBarrels: Int64
    @NSManaged public var spillsToClean: String?
    @NSManaged public var spillsToCleanComments: String?
    @NSManaged public var waterBarrels: Int64
    @NSManaged public var wellName: String?
    @NSManaged public var wellNumber: Int64
    @NSManaged public var section: NSSet?

}

// MARK: Generated accessors for section
extension InspectionFormEntity {

    @objc(addSectionObject:)
    @NSManaged public func addToSection(_ value: InspectionFormCategoryEntity)

    @objc(removeSectionObject:)
    @NSManaged public func removeFromSection(_ value: InspectionFormCategoryEntity)

    @objc(addSection:)
    @NSManaged public func addToSection(_ values: NSSet)

    @objc(removeSection:)
    @NSManaged public func removeFromSection(_ values: NSSet)

}

extension InspectionFormEntity : Identifiable {

}
