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
            //try self.database.run(EmployeeTable.drop(ifExists: true))
            try self.database.run(InspectionForm.drop(ifExists: true))
            try self.database.run(Pictures.drop(ifExists: true))
            try self.database.run(InspectionDescription.drop(ifExists: true))
            try self.database.run(fillTable.drop(ifExists:true))
            try self.database.run(wellImageTable.drop(ifExists:true))
            try self.database.run(wellDescTable.drop(ifExists:true))
            
            

            print("Tables deleted Sucessfully.")
        }catch{
            print("Cannot delete tables.")
        }
        
    }
    // EmployeeTable
    let EmployeeTable = Table("Employee")
    // Columns
    let Name = Expression<String>("Name")
    let employeeID = Expression<Int>("employeeID")
    let password = Expression<String>("password")
    // PRIMARY KEY(employeeID)

    func createEmployeeTable()
    {
        let createTable = self.EmployeeTable.create { (table) in
            table.column(self.Name)
            table.column(self.employeeID, primaryKey: true)
            table.column(self.password)
        }
        
        do{
            try self.database.run(createTable)
            print("Created Employee Table")
            
        }catch{
            print("Employee table already exists")
        }
        
    }
    func addEmployee(employeeID: Int, name: String, pw: String)
    {
        
        let insertEmployee = self.EmployeeTable.insert(self.employeeID <- employeeID, self.Name <- name, self.password <- pw)
        
        do{
            try self.database.run(insertEmployee)
            print("Inserted Employee")
        }catch{
            print(error)
        }

        
    }
    
    func listEmployees()
    {
        
        do{
            let employees = try! self.database.prepare(self.EmployeeTable)
            
            for employee in employees
            {
                print("Employee Name: \(employee[self.Name])")
                print("Employee ID: \(employee[self.employeeID])")
                //print("Employee Password: \(employee[self.password])")
                
            }
            
        }catch{
            print(error)
        }
    }
    func searchEmployee(name:String, password:String) -> Bool
    {
        var passed:Bool = false
        do{
            //Connecting to the database to prepare
            let employees = try! self.database.prepare(self.EmployeeTable)
            
            // Looping through the whole list of employees in the database
            for employee in employees
            {
                if(employee[self.Name] == name && employee[self.password] == password)
                {
                    passed = true
                }
                
            }
            
        }catch{
            print(error)
        }
        return passed
    }
    
    // InspectionForm Table
    let InspectionForm = Table("InspectionForm")
    let wellName = Expression<String>("wellName")
    let date = Expression<String>("date")
    let wellID = Expression<Int>("wellID")
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
            table.column(self.charID, primaryKey: true)
            table.column(self.wellID)
            table.foreignKey(self.wellID, references: self.InspectionForm, self.wellID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created InspectionDescription Table")
            
        }catch{
            print(error)
        }
        
    }
    
    func addWell(wellID: Int, Category: String, YesOrNo: String, comment: String)
    {
        
        
        let insertWell = self.InspectionDescription.insert(self.wellID <- wellID, self.Category <- Category, self.YesOrNo <- YesOrNo, self.comment <- comment)
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
                print("Well ID \(Well[self.wellID])")
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
            table.foreignKey(self.charID, references: self.InspectionDescription, self.charID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created Picture Table")
            
        }catch{
            print(error)
        }
        
    }
    func addPicture(PicID: Int, CategoryPics: String, charID: Int)
    {
        
        let insertPicture = self.Pictures.insert(self.PicID <- PicID, self.CategoryPics <- CategoryPics, self.charID <- charID)
        
        do{
            try self.database.run(insertPicture)
            print("Inserted Picture")
        }catch{
            print(error)
        }
        
    }
    func listPictures()
    {
        do{
            
            let Pics = try! self.database.prepare(self.Pictures)
            for Picture in Pics
            {
                print("Pic ID: \(Picture[PicID])")
                print("Char ID: \(Picture[self.charID])")
                //print("Well Name: \(Picture[PicOfWell])")
                //print("Date : \(Picture[PicOfTankBattery])")
                //print("Well Name: \(Picture[PicOfLocation])")
                //print("Date : \(Picture[PicOfLeaseRoad])")
                
            }
        }catch{
            print(error)
        }
    }
    //relationship tables
    //Fill Table
    let fillTable = Table("fillTable")
    
    func createFillTable()
    {
        let createTable = self.fillTable.create{    (table) in
            table.column(self.employeeID)
            table.column(self.wellID)
            table.column(self.date)
            table.foreignKey(self.employeeID, references: self.EmployeeTable, self.employeeID)
            table.foreignKey(self.wellID, references: self.InspectionForm, self.wellID)
            table.foreignKey(self.date, references: self.InspectionForm, self.date)
        }
        
        do{
            try self.database.run(createTable)
            print("Created fillTable Table")
            
        }catch{
            print(error)
        }
    }
    func addFill(wellID: Int, date: String)
    {
        
        let insertFill = self.fillTable.insert(self.employeeID <- employeeID, self.wellID <- wellID, self.date <- date)
        
        do{
            try self.database.run(insertFill)
            print("Inserted Fill")
        }catch{
            print(error)
        }

        
    }
    func listFill()
    {
        do{
            let fills = try! self.database.prepare(self.fillTable)
            
            for fill in fills
            {
                print("Employee ID: \(fill[self.employeeID])")
                print("Well ID: \(fill[self.wellID])")
                print("Date: \(fill[self.date])")
            }
        }catch{
            print(error)
        }
    }
    let wellImageTable = Table("wellImageTable")
    
    func createWellImageTable()
    {
        let createTable = self.wellImageTable.create{   (table) in
            table.column(self.wellID)
            table.column(self.date)
            table.column(self.PicID)
            table.foreignKey(self.wellID, references: InspectionForm, self.wellID)
            table.foreignKey(self.date, references: InspectionForm, self.date)
            table.foreignKey(self.PicID, references: Pictures, self.PicID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created wellImageTable Table")
            
        }catch{
            print(error)
        }
    }
    func addWellImage(wellID: Int, PicID: Int, date: String)
    {
        
        let insertWellImage = self.wellImageTable.insert(self.wellID <- wellID, self.date <- date)
        
        do{
            try self.database.run(insertWellImage)
            print("Inserted WellImage")
        }catch{
            print(error)
        }

        
    }
    func listWellImage()
    {
        do{
            let wellImages = try! self.database.prepare(self.wellImageTable)
            
            for wellImage in wellImages
            {
                print("Well ID: \(wellImage[self.wellID])")
                print("Date: \(wellImage[self.date])")
                print("Pic ID: \(wellImage[self.PicID])")
            }
        }catch{
            print(error)
        }
    }
    
    //WellDescription:
    let wellDescTable = Table("wellDescTable")

    func createWellDescTable()
    {
        let createTable = self.wellDescTable.create{   (table) in
            table.column(self.wellID)
            table.column(self.date)
            table.column(self.charID)
            table.foreignKey(self.wellID, references: InspectionForm, self.wellID)
            table.foreignKey(self.date, references: InspectionForm, self.date)
            table.foreignKey(self.charID, references: InspectionDescription, self.charID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created wellDescTable Table")
            
        }catch{
            print(error)
        }
    }
    func addWellDesc(wellID: Int, date: String)
    {
        
        let insertWellDesc = self.wellDescTable.insert(self.wellID <- wellID,  self.date <- date)
        
        do{
            try self.database.run(insertWellDesc)
            print("Inserted WellDesc")
        }catch{
            print(error)
        }

        
    }
    func listWellDesc()
    {
        do{
            let wellDescs = try! self.database.prepare(self.wellImageTable)
            
            for wellDesc in wellDescs
            {
                print("Well ID: \(wellDesc[self.wellID])")
                print("Date: \(wellDesc[self.date])")
                print("Char ID: \(wellDesc[self.charID])")
            }
        }catch{
            print(error)
        }
    }
   
}

