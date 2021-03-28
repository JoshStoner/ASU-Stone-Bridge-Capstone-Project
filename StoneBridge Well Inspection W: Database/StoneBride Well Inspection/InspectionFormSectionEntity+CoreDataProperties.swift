//
//  InspectionFormSectionEntity+CoreDataProperties.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 2/8/21.
//  Copyright © 2021 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension InspectionFormSectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InspectionFormSectionEntity> {
        return NSFetchRequest<InspectionFormSectionEntity>(entityName: "InspectionFormSectionEntity")
    }

    @NSManaged public var optComm: String?
    @NSManaged public var tagNum: Int64
    @NSManaged public var ynAns: String?
    @NSManaged public var toCategories: NSSet?
    @NSManaged public var pictureData: InspectionFormPicContainerEntity?

}

// MARK: Generated accessors for toCategories
extension InspectionFormSectionEntity {

    @objc(addToCategoriesObject:)
    @NSManaged public func addToToCategories(_ value: InspectionFormCategoryEntity)

    @objc(removeToCategoriesObject:)
    @NSManaged public func removeFromToCategories(_ value: InspectionFormCategoryEntity)

    @objc(addToCategories:)
    @NSManaged public func addToToCategories(_ values: NSSet)

    @objc(removeToCategories:)
    @NSManaged public func removeFromToCategories(_ values: NSSet)

}

extension InspectionFormSectionEntity : Identifiable {

}
