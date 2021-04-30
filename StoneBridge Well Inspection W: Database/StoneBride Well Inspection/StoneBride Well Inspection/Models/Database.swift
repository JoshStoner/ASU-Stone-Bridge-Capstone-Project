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
            table.column(self.employeeName)
            table.column(self.wellID, primaryKey: true)
        }
        
        do{
            try self.database.run(createTable)
            print("Created InspectionForm Table")
            
        }catch{
            print(error)
        }
        
    }
    
    func addInspection(wellID: Int, wellName: String, date: String, employeeName: String)
    {
        
        let insertInspection = self.InspectionForm.insert(self.wellID <- wellID, self.wellName <- wellName, self.date <- date, self.employeeName <- employeeName)
        
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
                print("Employee Name : \(Inspection[employeeName])")

            }
        }
        catch
        {
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
        }
        catch
        {
            print(error)
        }
    }
    let Pictures = Table("Pictures")
    let PicID = Expression<Int>("PicID")
    let CategoryPics = Expression<String>("CategoryPics")
    
    func createPictureTable()
    {
        let createTable = self.Pictures.create { (table) in
            table.column(self.PicID, primaryKey: .autoincrement)
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
    func addPicture(image: UIImage, charID: Int, wellID: Int, date: String)
    {
        let picture: String = convertImageToBase64(image: image)
        let insertPicture = self.Pictures.insert(self.CategoryPics <- picture, self.charID <- charID, self.wellID <- wellID, self.date <- date)
            
        do{
            try self.database.run(insertPicture)
            print("Inserted Picture")
        }catch
        {
            print("Failed to insert Picture")
        }
            
    }
    
    func convertImageToBase64(image:UIImage) -> String
    {
        let imageData = image.jpegData(compressionQuality: 1.0)
        // Convert it into string64
        let tempPString64 = imageData?.base64EncodedString(options: .endLineWithLineFeed)
        let picture : String = tempPString64!

        return picture
        
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
                print("Picture String: \(Picture[self.CategoryPics])")
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
        let Description = self.InspectionDescription.filter(self.wellID == wellID && self.Category == Category)
        
        // Update comments and YesOrNo's
        let updateInspectionForm = Description.update(self.comment <- Comments, self.YesOrNo <- YesorNo)
        
        do{
            try self.database.run(updateInspectionForm)
            print("Updated Inspection Form successfully.")

        }catch{
            print("Failed to update")
            print(error);
        }
        
    }
    // This function updates the picture, however, if a new picture gets added. It wont add the picture to the database.
    func updatePictures(wellID: Int, charID: Int, image:UIImage, PicID: Int)
    {
        let pic = convertImageToBase64(image: image)
       
        
        let pictureFilter = self.Pictures.filter(self.wellID == wellID && self.charID == charID && self.PicID == PicID)
        let updatePictures = pictureFilter.update(self.CategoryPics <- pic)
            
        do{
            try self.database.run(updatePictures)
            print("Updated pictures successfully.")
        }catch{
            print("Failed to update")
            print(error);
        }
        
    }
    
    func deletePictures(wellID: Int, charID: Int, PicID: Int)
    {

        let pictureFilter = self.Pictures.filter(self.wellID == wellID && self.charID == charID && self.PicID == PicID)
        let deletePictures = pictureFilter.delete()
            
        do{
            try self.database.run(deletePictures)
            print("Deleted pictures successfully.")
        }catch{
            print("Failed to delete")
            print(error);
        }
        
    }
    func countPictures() -> Int
    {
        var count : Int = 0
        let pictureTable = try! self.database.prepare(self.Pictures)
        
        for pic in pictureTable
        {
            count = pic[PicID]
        }
        print("COUNT HERE: ")
        print(count)
        return count
    }
    
    //wName: String, wIDate: String
    func convertToCSV()
    {
        var a: NSObject? = nil
        var fetchedWellName: String = ""
        do
        {
            //let Inspections = try! self.database.prepare(self.InspectionForm)
            
            for Inspection in try database.prepare("SELECT wellName FROM InspectionForm")
            {
                print("Well Name: \(Inspection)")
                a = Inspection as NSObject
                
                let ifWellName = a?.description.split(separator: "\n")
                fetchedWellName = ifWellName![1].trimmingCharacters(in: .whitespacesAndNewlines)
                print("fetchedWellName = \(fetchedWellName)")
            }
            //var inspectionFormWellName = InspectionForm[wellName]
        }
        catch
        {
            print("Error trying to get the wellName: \(error)")
        }
        // this is for the file name
        let inspectionTitleC = "\(fetchedWellName)Categories.csv"
        // this is for the file name
        let inspectionTitleP = "\(fetchedWellName)Pictures.csv"
        
        let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let docsURL = URL(fileURLWithPath: docsPath).appendingPathComponent(inspectionTitleP)
        
        let output = OutputStream.toMemory()
        
        let csvw = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        
        
        let path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(inspectionTitleP) //i think the home directory hear adds it to docs
        
        
        
        //let sqlCmd = "SELECT * FROM tablename ORDER BY column DESC LIMIT 1;" //this is a query for selecting the most recent entry, not sure how to implement
        
        var csvTxtP = "Employee Name,Employee ID\n"
        
        //csvw?.writeField("Well ID")
        //csvw?.writeField("Well Name")
        //csvw?.writeField("Date")
        //csvw?.writeField("Employee")
        
        //csvw?.finishLine()
        
        //let iFTable = "Well ID,Well Name,Date,Employee\n"
        //csvTxt.append(iFTable)
        
        //let Inspections = try! self.database.prepare(self.InspectionForm)
        //print("InspectionForm: ")
        
        //for Inspection in Inspections
        //{
            //print("Well ID: \(Inspection[wellID])")
            //print("Well Name: \(Inspection[wellName])")
            //print("Date : \(Inspection[date])")
            
          //  let iFLine = "\(Inspection[self.wellID]),\(Inspection[self.wellName]),\(Inspection[self.date])\n"
           // csvTxt.append(iFLine)
            
           // csvw?.writeField("\(Inspection[self.wellID])")
            //csvw?.writeField("\(Inspection[self.wellName])")
            //csvw?.writeField("\(Inspection[self.date])")
            //csvw?.writeField("\(Inspection[self.employeeName])")
            
            //csvw?.finishLine()
            
        //}
        
        //csvw?.finishLine()
        
        csvw?.writeField("Pic ID")
        csvw?.writeField("Char ID")
        csvw?.writeField("Category of Pics")
        csvw?.writeField("Well ID")
        csvw?.writeField("Date")
        
        csvw?.finishLine()
        
        let pTable = "Pic ID,Char ID,Category of Pics,Well ID,Date\n"
        csvTxtP.append(pTable)
        
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
            csvTxtP.append(pLine)
            
            csvw?.writeField("\(Picture[self.PicID])")
            csvw?.writeField("\(Picture[self.charID])")
            csvw?.writeField("\(Picture[self.CategoryPics])")
            csvw?.writeField("\(Picture[self.wellID])")
            csvw?.writeField("\(Picture[self.date])")
            
            csvw?.finishLine()
        }
        
        csvw?.finishLine()
        
        csvw?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do{
            print("First buffer.write")
            print("docsURL = \(docsURL)")
            print("path = \(path)")
            //This would fail so I just commented it out
            //try csvTxtP.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            try buffer.write(to: docsURL)
            print("Passed buffer.write")
        }
            catch{
                print("failed to create file")
        }
        
        let docURL = URL(fileURLWithPath: docsPath).appendingPathComponent(inspectionTitleC)
        
        let outputs = OutputStream.toMemory()
        
        let csvws = CHCSVWriter(outputStream: outputs, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        let paths = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(inspectionTitleC) //i think the home directory hear adds it to docs
    
    //let sqlCmd = "SELECT * FROM tablename ORDER BY column DESC LIMIT 1;" //this is a query for selecting the most recent entry, not sure how to implement
    
        var csvTxtC = "Employee Name,Employee ID\n"
        
        csvws?.writeField("Category")
        csvws?.writeField("Y/N")
        csvws?.writeField("Comment")
        csvws?.writeField("Description ID")
        csvws?.writeField("Well ID")
        csvws?.writeField("Date")
        
        csvws?.finishLine()
        
        let weTable = "Category,Y/N,Comment,Description ID,Well ID,Date\n"
        csvTxtC.append(weTable)
        
        //let docURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        //let csvFile = docURL.appendingPathComponent(inspectionTitleP)
            
        //let exists = try! FileManager().fileExists(atPath: csvFile.path)
        
        let Wells = try! self.database.prepare(self.InspectionDescription)
        
        for Well in Wells
        {
            
            //print("Category: \(Well[self.Category])")
            //print("Y/N: \(Well[self.YesOrNo])")
            //print("Comment: \(Well[self.comment])")
            //print("Description ID: \(Well[self.charID])")
            //print("Well ID: \(Well[self.wellID])")
            
            let weLine = "\(Well[self.Category]),\(Well[self.YesOrNo]),\(Well[self.comment]),\(Well[self.charID]),\(Well[self.wellID])\n"
            csvTxtC.append(weLine)
            
            csvws?.writeField("\(Well[self.Category])")
            csvws?.writeField("\(Well[self.YesOrNo])")
            csvws?.writeField("\(Well[self.comment])")
            csvws?.writeField("\(Well[self.charID])")
            csvws?.writeField("\(Well[self.wellID])")
            csvws?.writeField("\(Well[self.date])")
            
            csvws?.finishLine()
        }
        csvws?.finishLine()
        
        csvws?.closeStream()
        
        let buffers = (outputs.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        //if(exists == true){
        //    print("exists")
        //}
        //else{
        do{
            print("Second buffers.write")
            print("docsURL = \(docsURL)")
            print("path = \(path)")
            //try csvTxtC.write(to: paths!, atomically: true, encoding: String.Encoding.utf8)
            try buffers.write(to: docURL)
            print("Passed buffers.write")
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
        //}
   
   
}

