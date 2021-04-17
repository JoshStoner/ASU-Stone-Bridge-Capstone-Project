//
//  InspectionForm.swift
//  CapstoneSQLITE
//
//  Created by Randy Tran on 11/10/20.
//

import Foundation
// https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#table-constraints
// This library below is from github to make creating tables easier
import SQLite
import UIKit

class Database
{
    // Need this global var to use this database throughout the project
    var database: Connection!

    
    func DatabaseConnection(){
        
        do{
            // Creating a file
            let file = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("InspectionForms").appendingPathExtension("sqlite3")
            // Creating a connection
            let database = try Connection(file.path)
            self.database = database
            print("Database is connected")
            
        }catch{
            print("Creating file error or connection error")
        }
       

    }
    // Deleteing all Tables
    func delete()
    {
        do{
            try self.database.run(InspectionForm.drop(ifExists: true))
            try self.database.run(Pictures.drop(ifExists: true))
            try self.database.run(InspectionDescription.drop(ifExists: true))            
            

            print("Tables deleted Sucessfully.")
        }catch{
            print("Cannot delete tables.")
        }
        
    }
    // InspectionForm Table
    let InspectionForm = Table("InspectionForm")
    let wellName = Expression<String>("wellName")
    let date = Expression<String>("date")
    let wellID = Expression<Int>("wellID")
    let employeeName = Expression<String>("Employee")
    // PRIMARY KEY(wellID)
    
    func createInspectionFormTable()
    {
        let createTable = self.InspectionForm.create { (table) in
            table.column(self.wellName)
            table.column(self.date)
            // Primary key will increment
            table.column(self.wellID, primaryKey: true)
        }
        
        do{
            try self.database.run(createTable)
            print("Created InspectionForm Table")
            
        }catch{
            print(error)
        }
        
    }
    
    func addInspection(wellID: Int, wellName: String, date: String)
    {
        
        let insertInspection = self.InspectionForm.insert(self.wellID <- wellID, self.wellName <- wellName, self.date <- date)
        
        do{
            try self.database.run(insertInspection)
            print("Inserted Inspection")
        }catch{
            print(error)
        }
        
    }
    
    func listInspectionForm()
    {
        do{
            
            let Inspections = try! self.database.prepare(self.InspectionForm)
            print("InspectionForm: ")
            
            for Inspection in Inspections
            {
                print("Well ID: \(Inspection[wellID])")
                print("Well Name: \(Inspection[wellName])")
                print("Date : \(Inspection[date])")
                
            }
        }catch{
            print(error)
        }
    }
    
   
    
    let InspectionDescription = Table("InspectionDescription")
    let charID = Expression<Int>("charID")
    let comment = Expression<String> ("comment")
    let Category = Expression<String>("Category")
    let YesOrNo = Expression<String>("Yes/No")
    
    func createInspectionDescriptionTable()
    {
        let createTable = self.InspectionDescription.create { (table) in
            
            table.column(self.comment)
            table.column(self.Category)
            table.column(self.YesOrNo)
            // NOT NULL CONSTRAINT
            table.column(self.charID)
            table.column(self.wellID)
            table.column(self.date)
            table.foreignKey(self.wellID, references: self.InspectionForm, self.wellID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created InspectionDescription Table")
            
        }catch{
            print(error)
        }
        
    }
    
    func addWell(wellID: Int, Category: String, YesOrNo: String, comment: String, charID: Int, date: String)
    {
        
        
        let insertWell = self.InspectionDescription.insert(self.wellID <- wellID, self.Category <- Category, self.YesOrNo <- YesOrNo, self.comment <- comment, self.charID <- charID, self.date <- date)
        do{
            try self.database.run(insertWell)
            print("Inserted Well")
        }catch{
            print(error)
        }
        
    }
    func listWell()
    {
        do{
            let Wells = try! self.database.prepare(self.InspectionDescription)
            
            for Well in Wells
            {
                
                print("Category: \(Well[self.Category])")
                print("Y/N: \(Well[self.YesOrNo])")
                print("Comment: \(Well[self.comment])")
                print("Description ID: \(Well[self.charID])")
                print("Well ID: \(Well[self.wellID])")
                print("Date: \(Well[self.date])")
            }
        }catch{
            print(error)
        }
    }
    let Pictures = Table("Pictures")
    let PicID = Expression<Int>("PicID")
    let CategoryPics = Expression<String>("CategoryPics")
    
    func createPictureTable()
    {
        let createTable = self.Pictures.create { (table) in
            table.column(self.PicID)
            table.column(self.CategoryPics)
            table.column(self.charID)
            //table.column(self.YesOrNo)
            //table.column(self.wellID)
            table.column(self.wellID)
            table.column(self.date)
            table.foreignKey(self.wellID, references: self.InspectionForm, self.wellID)
            table.foreignKey(self.charID, references: self.InspectionDescription, self.charID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created Picture Table")
            
        }catch{
            print(error)
        }
        
    }
    // charID is category.
    func addPicture(PicID: Int, image: UIImage, charID: Int, wellID: Int, date: String)
    {
        // Saves it into pngData
        let imageData = image.pngData()
        // Convert it into string64
        let tempPString64 = imageData?.base64EncodedString(options: .endLineWithLineFeed)
        let picture : String = tempPString64!
        let insertPicture = self.Pictures.insert(self.PicID <- PicID, self.CategoryPics <- picture, self.charID <- charID, self.wellID <- wellID, self.date <- date)
            
        do{
            try self.database.run(insertPicture)
            print("Inserted Picture")
        }catch
        {
            print("Failed to insert Picture")
        }
            
    }
    func listPictures()
    {
        do{
            let Pics = try! self.database.prepare(self.Pictures)
            for Picture in Pics
            {
                print("Pic ID: \(Picture[PicID])")
                print("Description ID: \(Picture[self.charID])")
                print("Well ID: \(Picture[self.wellID])")
                print("Date: \(Picture[self.date])")
                //I couldn't get this Picture String to print for me without XCode preventing me from printing anything from this method if I try to print this Picture String
                //print("Picture String: \(Picture[self.CategoryPics])")
                
                //print("Date : \(Picture[PicOfTankBattery])")
                //print("Well Name: \(Picture[PicOfLocation])")
                //print("Date : \(Picture[PicOfLeaseRoad])")
                
            }
        }catch{
            print(error)
        }
    }
    
    // Search function. Checks if the Inspection Form already exist
    func searchInspectionForm(wellID: Int, wellName: String, Date: String ) -> Bool
    {
        var passed:Bool = false
        do{
            //Connecting to the database to prepare
            let Inspections = try! self.database.prepare(self.InspectionForm)
            
            // Looping through the whole list of employees in the database
            for Inspection in Inspections
            {
                if(Inspection[self.wellID] == wellID && Inspection[self.wellName] == wellName && Inspection[self.date] ==  Date)
                {
                    passed = true
                }
                
            }
            
        }catch{
            print(error)
        }
        return passed
    }

    // Update function. Updates the inspection form if it already exists.
    
    func updateInspectionForm(wellID: Int, Comments: String, YesorNo: String, Category: String)
    {
        // Filter by wellID and category.
        let wellID = self.InspectionDescription.filter(self.wellID == wellID && self.Category == Category)
        // Update comments and YesOrNo's
        let updateInspectionForm = wellID.update(self.comment <- Comments, self.YesOrNo <- YesorNo)
        do{
            try self.database.run(updateInspectionForm)
        }catch{
            print("Failed to update")
            print(error);
        }
        
    }
    
    func convertToCSV()
    {
        var inspectionTitle = ""
       // let Inspections = try! self.database.prepare(self.InspectionForm)
        // wName = "\(InspectionForm[wellName])"
        //let wIDate = ", \(InspectionForm[date])"
        inspectionTitle = "\(InspectionForm[wellName])" + "\(InspectionForm[date])" + ".csv" // this is for the file name
        
        
        let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let docsURL = URL(fileURLWithPath: docsPath).appendingPathComponent(inspectionTitle)
        
        let output = OutputStream.toMemory()
        
        let csvw = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        
        
        let path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(inspectionTitle) //i think the home directory hear adds it to docs
        
        //let sqlCmd = "SELECT * FROM tablename ORDER BY column DESC LIMIT 1;" //this is a query for selecting the most recent entry, not sure how to implement
        
        var csvTxt = "Employee Name,Employee ID\n"
        
        csvw?.writeField("Well ID")
        csvw?.writeField("Well Name")
        csvw?.writeField("Date")
        
        csvw?.finishLine()
        
        let iFTable = "Well ID,Well Name,Date\n"
        csvTxt.append(iFTable)
        
        let Inspections = try! self.database.prepare(self.InspectionForm)
        print("InspectionForm: ")
        
        for Inspection in Inspections
        {
            //print("Well ID: \(Inspection[wellID])")
            //print("Well Name: \(Inspection[wellName])")
            //print("Date : \(Inspection[date])")
            
            let iFLine = "\(Inspection[self.wellID]),\(Inspection[self.wellName]),\(Inspection[self.date])\n"
            csvTxt.append(iFLine)
            
            csvw?.writeField("\(Inspection[self.wellID])")
            csvw?.writeField("\(Inspection[self.wellName])")
            csvw?.writeField("\(Inspection[self.date])")
            
            csvw?.finishLine()
            
        }
        
        csvw?.finishLine()
        
        csvw?.writeField("Well ID")
        csvw?.writeField("Date")
        csvw?.writeField("Pic ID")
        
        csvw?.finishLine()
        
        csvw?.writeField("Pic ID")
        csvw?.writeField("Char ID")
        
        csvw?.finishLine()
        
        let pTable = "Pic ID,Char ID\n"
        csvTxt.append(pTable)
        
        let Pics = try! self.database.prepare(self.Pictures)
        for Picture in Pics
        {
            //print("Pic ID: \(Picture[PicID])")
            //print("Char ID: \(Picture[self.charID])")
            //I couldn't get this Picture String to print for me without XCode preventing me from printing anything from this method if I try to print this Picture String
            //print("Picture String: \(Picture[self.CategoryPics])")
            
            //print("Date : \(Picture[PicOfTankBattery])")
            //print("Well Name: \(Picture[PicOfLocation])")
            //print("Date : \(Picture[PicOfLeaseRoad])")
            
            let pLine = "\(Picture[self.PicID]),\(Picture[self.charID])\n"
            csvTxt.append(pLine)
            
            csvw?.writeField("\(Picture[self.PicID])")
            csvw?.writeField("\(Picture[self.charID])")
            
            csvw?.finishLine()
        }
        
        csvw?.finishLine()
        
        csvw?.writeField("Category")
        csvw?.writeField("Y/N")
        csvw?.writeField("Comment")
        csvw?.writeField("Description ID")
        csvw?.writeField("Well ID")
        
        csvw?.finishLine()
        
        let weTable = "Category,Y/N,Comment,Description ID,Well ID\n"
        csvTxt.append(weTable)
        
        let docURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let csvFile = docURL.appendingPathComponent(inspectionTitle)
            
        let exists = try! FileManager().fileExists(atPath: csvFile.path)
        
        let Wells = try! self.database.prepare(self.InspectionDescription)
        
        for Well in Wells
        {
            
            //print("Category: \(Well[self.Category])")
            //print("Y/N: \(Well[self.YesOrNo])")
            //print("Comment: \(Well[self.comment])")
            //print("Description ID: \(Well[self.charID])")
            //print("Well ID: \(Well[self.wellID])")
            
            let weLine = "\(Well[self.Category]),\(Well[self.YesOrNo]),\(Well[self.comment]),\(Well[self.charID]),\(Well[self.wellID])\n"
            csvTxt.append(weLine)
            
            csvw?.writeField("\(Well[self.Category])")
            csvw?.writeField("\(Well[self.YesOrNo])")
            csvw?.writeField("\(Well[self.comment])")
            csvw?.writeField("\(Well[self.charID])")
            csvw?.writeField("\(Well[self.wellID])")
            
            csvw?.finishLine()
        }
        
        csvw?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        if(exists == true){
            print("exists")
        }
        else{
            do{
                //try csvTxt.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                try buffer.write(to: docsURL)
            }
                catch{
                    print("failed to create file")
                }
            
            
            
            
            
            
            
            //NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
            
            
            
           /* NSString docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]*/
            
            //NSMutableArray *arrayEmp = //[NSMutableArray new]
            //NSArray arrayWithObjects:@"
           // let employees = try! self.database.prepare(self.EmployeeTable)
            //for employee in employees
            //{
                
            //}
            }
        }
   
   
}

