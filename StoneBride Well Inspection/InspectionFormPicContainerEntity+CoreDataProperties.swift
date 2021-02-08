//
//  InspectionFormPicContainerEntity+CoreDataProperties.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 2/8/21.
//  Copyright © 2021 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension InspectionFormPicContainerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InspectionFormPicContainerEntity> {
        return NSFetchRequest<InspectionFormPicContainerEntity>(entityName: "InspectionFormPicContainerEntity")
    }

    @NSManaged public var hasPics: Bool
    @NSManaged public var pic: NSSet?
    @NSManaged public var toSection: InspectionFormSectionEntity?

}

// MARK: Generated accessors for pic
extension InspectionFormPicContainerEntity {

    @objc(addPicObject:)
    @NSManaged public func addToPic(_ value: InspectionFormPicturesEntity)

    @objc(removePicObject:)
    @NSManaged public func removeFromPic(_ value: InspectionFormPicturesEntity)

    @objc(addPic:)
    @NSManaged public func addToPic(_ values: NSSet)

    @objc(removePic:)
    @NSManaged public func removeFromPic(_ values: NSSet)

}

extension InspectionFormPicContainerEntity : Identifiable {

}
