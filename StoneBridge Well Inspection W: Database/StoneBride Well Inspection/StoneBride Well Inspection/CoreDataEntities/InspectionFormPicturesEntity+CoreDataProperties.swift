//
//  InspectionFormPicturesEntity+CoreDataProperties.swift
//  StoneBridge Well Inspection
//
//  Created by Tyler Ipema on 4/15/21.
//  Copyright © 2021 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension InspectionFormPicturesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InspectionFormPicturesEntity> {
        return NSFetchRequest<InspectionFormPicturesEntity>(entityName: "InspectionFormPicturesEntity")
    }

    @NSManaged public var picData: Data?
    @NSManaged public var picTag: Int64
    @NSManaged public var picURL: String?
    @NSManaged public var toPicContainer: InspectionFormPicContainerEntity?

}

extension InspectionFormPicturesEntity : Identifiable {

}
