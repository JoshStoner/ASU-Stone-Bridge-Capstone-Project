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

class InspectionForms
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
            
        }catch{
            print("Creating file error or connection error")
        }
       

    }
    // Deleteing all Tables
    func delete()
    {
        do{
            try self.database.run(EmployeeTable.drop(ifExists: true))
            try self.database.run(InspectionForm.drop(ifExists: true))
            try self.database.run(Pictures.drop(ifExists: true))
            try self.database.run(wellCharacteristics.drop(ifExists: true))
        
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
            print(error)
        }
        
    }
    func addEmployee(name: String, pw: String)
    {
        
        let insertEmployee = self.EmployeeTable.insert(self.Name <- name, self.password <- pw)
        
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
                print("Employee Password: \(employee[self.password])")
                
            }
            
            
        }catch{
            print(error)
        }
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
            // This is saying there cannot be a duplicate ID
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
    
    func addInspection(wellName: String, date: String)
    {
        
        let insertInspection = self.InspectionForm.insert(self.wellName <- wellName, self.date <- date)
        
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
    
    let Pictures = Table("Pictures")
    let PicID = Expression<Int>("PicID")
    let PicOfWell = Expression<Data>("PicOfWell")
    let PicOfTankBattery = Expression<Data>("PicOfTankBattery")
    let PicOfLocation = Expression<Data>("PicOfLocation")
    let PicOfLeaseRoad = Expression<Data>("PicOfLeaseRoad")
    let YesOrNo = Expression<String>("Yes/No")
    
    func createPictureTable()
    {
        let createTable = self.Pictures.create { (table) in
            table.column(self.PicID)
            table.column(self.PicOfWell)
            table.column(self.PicOfTankBattery)
            table.column(self.PicOfLocation)
            table.column(self.PicOfLeaseRoad)
            table.column(self.YesOrNo)
            table.column(self.wellID)
            table.foreignKey(self.wellID, references: self.InspectionForm, self.wellID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created Picture Table")
            
        }catch{
            print(error)
        }
        
    }
    func addPicture(PicOfWell: Data, PicOfTankBattery: Data, PicOfLocation: Data, PicOfLeaseRoad: Data, YesOrNo: String)
    {
        
        let insertPicture = self.Pictures.insert(self.PicOfWell <- PicOfWell, self.PicOfTankBattery <- PicOfTankBattery, self.PicOfLocation <- PicOfLocation, self.PicOfLeaseRoad <- PicOfLeaseRoad, self.YesOrNo <- YesOrNo)
        
        do{
            try self.database.run(insertPicture)
            print("Inserted Picture")
        }catch{
            print(error)
        }
        
    }
    
    let wellCharacteristics = Table("wellCharacteristics")
    let charID = Expression<String>("charID")
    let comment = Expression<String> ("comment")
    let Category = Expression<String>("Category")
    func createWellCharacteristicsTable()
    {
        let createTable = self.wellCharacteristics.create { (table) in
            
            table.column(self.comment)
            table.column(self.Category)
            table.column(self.YesOrNo)
            // NOT NULL CONSTRAINT
            table.column(self.wellID, primaryKey: true)
            table.foreignKey(self.wellID, references: self.InspectionForm, self.wellID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created WellCharacteristics Table")
            
        }catch{
            print(error)
        }
        
    }
    
    func addWell(comment: String, Category: String, YesOrNo: String)
    {
        
        let insertWell = self.wellCharacteristics.insert(self.comment <- comment, self.Category <- Category, self.YesOrNo <- YesOrNo)
        
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
            let Wells = try! self.database.prepare(self.wellCharacteristics)
            
            for Well in Wells
            {
                
                print("Category: \(Well[self.Category])")
                print("Y/N: \(Well[self.YesOrNo])")
                print("Comment: \(Well[self.comment])")
                print("Well ID: \(Well[self.wellID])")
                
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
            table.foreignKey(self.employeeID, references: EmployeeTable.employeeID)
            table.foreignKey(self.wellID, references: InspectionForm.wellID)
            table.foreignKey(self.date, references: InspectionForm.date)
        }
        
        do{
            try self.database.run(createTable)
            print("Created fillTable Table")
            
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
    
    //WellImages:
    let wellImageTable = Table("wellImageTable")
    
    func createWellImageTable()
    {
        let createTable = self.wellImageTable.create{   (table) in
            table.column(self.wellID)
            table.column(self.date)
            table.picID(self.PicID)
            table.foreignKey(self.wellID, references: InspectionForm.wellID)
            table.foreignKey(self.date, references: InspectionForm.date)
            table.foreignKey(self.PicID, reference: Pictures.PicID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created wellImageTable Table")
            
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
                print("Well ID: \(fill[self.wellID])")
                print("Date: \(fill[self.date])")
                print("Pic ID: \(fill[self.PicID])")
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
            table.charID(self.charID)
            table.foreignKey(self.wellID, references: InspectionForm.wellID)
            table.foreignKey(self.date, references: InspectionForm.date)
            //table.foreignKey(self.charID, reference: Pictures.charID)
        }
        
        do{
            try self.database.run(createTable)
            print("Created wellDescTable Table")
            
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
                print("Well ID: \(fill[self.wellID])")
                print("Date: \(fill[self.date])")
                //print("Char ID: \(fill[self.charID])")
            }
        }catch{
            print(error)
        }
    }
}

