//
//  InspectionFormPicturesEntity+CoreDataProperties.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 2/8/21.
//  Copyright © 2021 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension InspectionFormPicturesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InspectionFormPicturesEntity> {
        return NSFetchRequest<InspectionFormPicturesEntity>(entityName: "InspectionFormPicturesEntity")
    }

    @NSManaged public var picTag: Int64
    @NSManaged public var picData: Data?
    @NSManaged public var toPicContainer: InspectionFormPicContainerEntity?

}

extension InspectionFormPicturesEntity : Identifiable {

}
