//
//  InspectionFormEntity+CoreDataClass.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 11/7/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import Foundation
import CoreData

@objc(InspectionFormEntity)
public class InspectionFormEntity: NSManagedObject
{
    func set(date: String, inspectionDone: String, wellName: String, wellNumber: Int, spillsToClean: String, spillsToCleanComments: String, oilBarrels: Int, waterBarrels: Int)
    {
        self.date = date
        self.inspectionDone = inspectionDone
        self.wellName = wellName
        self.wellNumber = Int64(wellNumber)
        self.spillsToClean = spillsToClean
        self.spillsToCleanComments = spillsToCleanComments
        self.oilBarrels = Int64(oilBarrels)
        self.waterBarrels = Int64(waterBarrels)
    }
    
    func getDate() -> String
    {
        return self.date!
    }
}
