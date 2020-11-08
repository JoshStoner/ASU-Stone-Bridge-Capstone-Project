//
//  InspectionFormEntity+CoreDataProperties.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 11/7/20.
//  Copyright © 2020 ASU. All rights reserved.
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
    @NSManaged public var wellName: String?
    @NSManaged public var wellNumber: Int64
    @NSManaged public var spillsToClean: String?
    @NSManaged public var spillsToCleanComments: String?
    @NSManaged public var oilBarrels: Int64
    @NSManaged public var waterBarrels: Int64

}

extension InspectionFormEntity : Identifiable {

}
