//
//  inspectionList.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//

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
