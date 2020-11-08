//
//  inspectionList.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//



/* This file was only for testing purposes and
 * will not be needed for final implementation.
 * This file was needed before the core data was
 * implemented but it should no longer be needed
 * but I leaving it here just in case for now.
 */


import Foundation

class inspectionList
{

    var inspectionFormList:[inspectionForm] = []
    
    func getCount() -> Int
    {
        return inspectionFormList.count
    }
    
    func getDate(item:Int) -> String
    {
        return inspectionFormList[item].date!
    }
    
    func getInspectionDone(item:Int) -> String
    {
        return inspectionFormList[item].inspectionDone!
    }
    
    func getWellName(item:Int) -> String
    {
        return inspectionFormList[item].wellName!
    }
    
    func getWellNumber(item:Int) -> Int
    {
        return inspectionFormList[item].wellNumber!
    }
    
    
    
    func getSpillsToClean(item:Int) -> String
    {
        return inspectionFormList[item].spillsToClean!
    }
    
    func getSpillsToCleanComments(item:Int) -> String
    {
        return inspectionFormList[item].spillsToCleanComments!
    }
    
    
    
    
    func getOilBarrels(item:Int) -> Int
    {
        return inspectionFormList[item].oilBarrels!
    }
    
    func getWaterBarrels(item:Int) -> Int
    {
        return inspectionFormList[item].waterBarrels!
    }
    
    func removeForm(item:Int)
    {
        inspectionFormList.remove(at: item)
    }
    
    func removeAllForms()
    {
        var i = getCount() - 1
        
        while i >= 0
        {
            removeForm(item: i)
            i -= 1
        }
    }
    
    func addForm(da: String, inspDone: String, weName: String, weNum: Int, spls: String, splsCom: String, oil: Int, water: Int)
    {
        let inspectForm = inspectionForm(d: da, inspecDone: inspDone, wName: weName, wNum: weNum, spills: spls, spillsCom: splsCom, oilBBLS: oil, waterBBLS: water)
        inspectionFormList.append(inspectForm)
    }

}

class inspectionForm
{
    var date:String?
    var inspectionDone:String?
    var wellName:String?
    var wellNumber:Int?
    /*var wellPictures:String?
    var wellPicturesComments:String?
    var tankBatteryPictures:String?
    var tankBatteryPicturesComments:String?
    var locationPictures:String?
    var locationPicturesComments:String?
    var leaseRoadPictures:String?
    var leaseRoadPicturesComments:String?*/
    var spillsToClean:String?
    var spillsToCleanComments:String?
    
    var oilBarrels:Int?
    var waterBarrels:Int?
    
    init(d: String, inspecDone: String, wName: String, wNum: Int, spills: String, spillsCom: String, oilBBLS: Int, waterBBLS:Int)
    {
        date = d
        inspectionDone = inspecDone
        wellName = wName
        wellNumber = wNum
        
        spillsToClean = spills
        spillsToCleanComments = spillsCom
        
        oilBarrels = oilBBLS
        waterBarrels = waterBBLS
    }
}
