//
//  ViewController.swift
//  CapstoneSQLITE
//
//  Created by Randy Tran on 11/10/20.
//

import UIKit

class ViewController: UIViewController {
    var Inspection = InspectionForms()
    
    @IBOutlet weak var EnteredEmployeeID: UITextField!
    @IBOutlet weak var EnteredPassword: UITextField!
    @IBOutlet weak var EnteredName: UITextField!
    @IBOutlet weak var EnteredWellName: UITextField!
    
    @IBOutlet weak var EnteredDate: UITextField!
    @IBOutlet weak var EnteredComment: UITextField!
    @IBOutlet weak var EnteredY_N: UITextField!
    @IBOutlet weak var EnteredWellCategory: UITextField!
    
    @IBOutlet weak var EnteredWorkingEmployeeID: UITextField!
    @IBOutlet weak var EnteredWellID: UITextField!
    @IBOutlet weak var EnteredCharID: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Inspection.DatabaseConnection()
        
    }
    @IBAction func createTables(_ sender: Any) {
        Inspection.createEmployeeTable()
        Inspection.createInspectionFormTable()
        Inspection.createPictureTable()
        Inspection.createInspectionDescriptionTable()
        
        Inspection.createFillTable()
        Inspection.createWellImageTable()
        Inspection.createWellDescTable()
    }
    @IBAction func addEmployee(_ sender: Any)
    {
        Inspection.addEmployee(employeeID: Int(EnteredEmployeeID.text!)!, name: EnteredName.text!, pw: EnteredPassword.text!)
        Inspection.listEmployees()
    }
    
    @IBAction func addInspectionForm(_ sender: Any)
    {
        Inspection.addInspection(wellID: Int(EnteredWellID.text!)!, wellName: EnteredWellName.text!, date: EnteredDate.text!)
        Inspection.addWell(charID: Int(EnteredCharID.text!)!, comment: EnteredComment.text!, Category: EnteredWellCategory.text!, YesOrNo: EnteredY_N.text!)
        Inspection.addFill(employeeID: Int(EnteredWorkingEmployeeID.text!)!, wellID: Int(EnteredWellID.text!)!, date: EnteredDate.text!)
        Inspection.addWellDesc(wellID: Int(EnteredWellID.text!)!, charID: Int(EnteredCharID.text!)!, date: EnteredDate.text!)
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        Inspection.delete()
        
    }
    
    @IBAction func listAll(_ sender: Any) {
        Inspection.listInspectionForm()

        Inspection.listWell()

    }
    

        
}

