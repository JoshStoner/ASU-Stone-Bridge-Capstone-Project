//
//  inspectionFormModel.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 11/7/20.
//  Copyright © 2020 ASU. All rights reserved.
//
import UIKit
import Foundation
import CoreData

public class inspectionFormModel
{
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext)
    {
        managedObjectContext = context
    }
    
    //update the inspection form list for the tableView
    func updateList() -> [InspectionFormEntity]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionFormEntity")
        
        //sort here if wanted
        //let sort = NSSortDescriptor(key: "wellName", ascending: true)
        //fetchRequest.sortDescriptors = [sort]
        
        let fetchResults = ((try? managedObjectContext?.fetch(fetchRequest)) as? [InspectionFormEntity])!
        
        return fetchResults
    }
    
    //returns the number of inspection forms saved in core data
    func fetchCount() -> Int
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionFormEntity")
        
        let fetchResults = ((try? managedObjectContext?.fetch(fetchRequest)) as? [InspectionFormEntity])!
        
        return fetchResults.count
    }
    
    func updateContext(contextObject: InspectionFormEntity, d: String, inspecDone: String, wName: String, wNum: Int,  categories: [InspectionCategory])
    {
        contextObject.date = d
        contextObject.inspectionDone = inspecDone
        contextObject.wellName = wName
        contextObject.wellNumber = Int64(wNum)
        
        //print("Hey ur before the deltion")
        //Should remove every category currently saved
        let deletingOldSections = contextObject.section
        contextObject.removeFromSection(deletingOldSections!)
        //print("Hey it should be deleted")
        
        var tagIndex = 0
        let maxTag = 30
        while(tagIndex < maxTag)
        {
            //print(categories[tagIndex].tag)
            let section = InspectionFormCategoryEntity(context: self.managedObjectContext!)
            
            section.tagN = Int64(categories[tagIndex].tag)
            
            let sectionCategories = InspectionFormSectionEntity(context: self.managedObjectContext!)
            
            sectionCategories.tagNum = Int64(categories[tagIndex].tag)
            sectionCategories.ynAns = categories[tagIndex].inspectionYNField?.text
            sectionCategories.optComm = categories[tagIndex].inspectionComment.text
            
            section.category = sectionCategories
            
            let pictures = InspectionFormPicContainerEntity(context:  self.managedObjectContext!)
            
            if(tagIndex < 30)
            {
                pictures.hasPics = true
                
                
                
                let pics = categories[tagIndex].getImages()
                let pURLS = categories[tagIndex].getURLS()
                print("Hey pics is next")
                print(pics)
                print(pURLS)
                
                var i = 0
                while (i < pics.count)
                {
                    let pictureData = InspectionFormPicturesEntity(context: self.managedObjectContext!)
                    pictureData.picURL = pURLS[i]
                    pictureData.picData = pics[i].jpegData(compressionQuality: 1.0)
                    pictureData.picTag = Int64(i)
                    pictures.addToPic(pictureData)
                    i += 1
                }
                
            }
            else
            {
                pictures.hasPics = false
            }
            sectionCategories.pictureData = pictures
         
            contextObject.addToSection(section)
            tagIndex += 1
        }
        
        do
        {
            try self.managedObjectContext!.save()
            print("Successfully updated core data")
        }
        catch
        {
            print("An error occured when trying to save this inspection form to Core Data")
        }
    }
    
    //Save an inspection form
    func saveContext(d: String, inspecDone: String, wName: String, wNum: Int, categories: [InspectionCategory]) -> InspectionFormEntity?
    {
        let newInspectionForm = InspectionFormEntity(context: self.managedObjectContext!)
        
        newInspectionForm.date = d
        newInspectionForm.inspectionDone = inspecDone
        newInspectionForm.wellName = wName
        newInspectionForm.wellNumber = Int64(wNum)
        
        //Figure out how many tags there are and set it to maxTag
        var tagIndex = 0
        let maxTag = 30
        while(tagIndex < maxTag)
        {
            //print(categories[tagIndex].tag)
            let section = InspectionFormCategoryEntity(context: self.managedObjectContext!)
            
            section.tagN = Int64(categories[tagIndex].tag)
            
            let sectionCategories = InspectionFormSectionEntity(context: self.managedObjectContext!)
            
            sectionCategories.tagNum = Int64(categories[tagIndex].tag)
            sectionCategories.ynAns = categories[tagIndex].inspectionYNField?.text
            sectionCategories.optComm = categories[tagIndex].inspectionComment.text
            
            section.category = sectionCategories
            
            let pictures = InspectionFormPicContainerEntity(context:  self.managedObjectContext!)
            
            if(tagIndex < 30)//4)
            {
                pictures.hasPics = true
                
                
                
                let pics = categories[tagIndex].getImages()
                let pURLS = categories[tagIndex].getURLS()
                print("Hey pics is next")
                print(pics)
                print(pURLS)
                
                var i = 0
                while (i < pics.count)
                {
                    let pictureData = InspectionFormPicturesEntity(context: self.managedObjectContext!)
                    pictureData.picURL = pURLS[i]
                    pictureData.picData = pics[i].jpegData(compressionQuality: 1.0)
                    pictureData.picTag = Int64(i)
                    pictures.addToPic(pictureData)
                    i += 1
                }
                
            }
            else
            {
                pictures.hasPics = false
            }
            sectionCategories.pictureData = pictures
         
            newInspectionForm.addToSection(section)
            tagIndex += 1
        }
        
        do
        {
            try self.managedObjectContext!.save()
            return newInspectionForm
        }
        catch
        {
            print("An error occured when trying to save this inspection form to Core Data")
        }
        return nil
    }
    
    //remove specific inspection form from coredata
    func deleteContext(inspecEntity: InspectionFormEntity)
    {
        managedObjectContext?.delete(inspecEntity)
        do
        {
            try managedObjectContext?.save()
        }
        catch
        {
            print("An error occured when trying to delete this inspection form")
        }
    }
    
    //Remove all data stored in coredata
    func clearData()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionFormEntity")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext!.execute(deleteRequest)
            try managedObjectContext!.save()
        }
        catch _ as NSError
        {
            print("An error occured when trying to delete all inspection forms in the table")
        }
    }
    
    func searchEnt(sWellName: String, sDate: String, sWellNumber: Int, sInspectionDone: String) -> InspectionFormEntity?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionFormEntity")
        
        let fetchResults = ((try? managedObjectContext?.fetch(fetchRequest)) as? [InspectionFormEntity])!
        
        for contextObject in fetchResults
        {
            if contextObject.date == sDate && contextObject.wellName == sWellName && contextObject.wellNumber == Int64(sWellNumber) && contextObject.inspectionDone == sInspectionDone
            {
                return contextObject
            }
        }
        
        return nil
    }
}
