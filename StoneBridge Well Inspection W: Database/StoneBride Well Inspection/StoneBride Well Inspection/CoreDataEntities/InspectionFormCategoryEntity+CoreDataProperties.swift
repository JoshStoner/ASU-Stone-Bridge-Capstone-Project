//
//  InspectionFormCategoryEntity+CoreDataProperties.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 2/3/21.
//  Copyright © 2021 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension InspectionFormCategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InspectionFormCategoryEntity> {
        return NSFetchRequest<InspectionFormCategoryEntity>(entityName: "InspectionFormCategoryEntity")
    }

    @NSManaged public var optComm: String?
    @NSManaged public var ynAns: String?
    @NSManaged public var tagNum: Int64
    @NSManaged public var sectionNum: InspectionFormEntity?

}

extension InspectionFormCategoryEntity : Identifiable {

}
