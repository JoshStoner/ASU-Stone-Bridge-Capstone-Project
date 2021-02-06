//
//  ViewController.swift
//  CapstoneSQLITE
//
//  Created by Randy Tran on 11/10/20.
//

import UIKit

class ViewController: UIViewController {
    var Inspection = InspectionForms()
    
    @IBOutlet weak var EnteredPassword: UITextField!
    @IBOutlet weak var EnteredName: UITextField!
    @IBOutlet weak var EnteredWellName: UITextField!
    
    @IBOutlet weak var EnteredDate: UITextField!
    @IBOutlet weak var EnteredComment: UITextField!
    @IBOutlet weak var EnteredY_N: UITextField!
    @IBOutlet weak var EnteredWellCategory: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Inspection.DatabaseConnection()
        
    }
    @IBAction func createTables(_ sender: Any) {
        Inspection.createEmployeeTable()
        Inspection.createInspectionFormTable()
        Inspection.createPictureTable()
        Inspection.createWellCharacteristicsTable()
    }
    @IBAction func addEmployee(_ sender: Any)
    {
        Inspection.addEmployee(name: EnteredName.text!, pw: EnteredPassword.text!)
        Inspection.listEmployees()
    }
    
    @IBAction func addInspectionForm(_ sender: Any)
    {
        Inspection.addInspection(wellName: EnteredWellName.text!, date: EnteredDate.text!)
        
        Inspection.addWell(comment: EnteredComment.text!, Category: EnteredWellCategory.text!, YesOrNo: EnteredY_N.text!)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        Inspection.delete()
        
    }
    
    @IBAction func listAll(_ sender: Any) {
        Inspection.listInspectionForm()

        Inspection.listWell()

    }
}

