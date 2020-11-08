//
//  inspectionFormModel.swift
//  StoneBride Well Inspection
//
//  Created by Tyler Ipema on 11/7/20.
//  Copyright © 2020 ASU. All rights reserved.
//

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
    
    //date: String, inspectionDone: String, wellName: String, wellNumber: Int, spillsToClean: String, spillsToCleanComments: String, oilBarrels: Int, waterBarrels: Int
    
    //Save an inspection form
    func saveContext(d: String, inspecDone: String, wName: String, wNum: Int, spilToClean: String, spilToCleanComm: String, oBarrels: Int, wBarrels: Int)
    {
        let newInspectionForm = InspectionFormEntity(context: self.managedObjectContext!)
        
        newInspectionForm.set(date: d, inspectionDone: inspecDone, wellName: wName, wellNumber: wNum, spillsToClean: spilToClean, spillsToCleanComments: spilToCleanComm, oilBarrels: oBarrels, waterBarrels: wBarrels)
        
        //newInspectionForm.date = d
        //newInspectionForm.wellName = wName
        
        do
        {
            try self.managedObjectContext!.save()
        }
        catch
        {
            print("An error occured when trying to save this inspection form to Core Data")
        }
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
}
