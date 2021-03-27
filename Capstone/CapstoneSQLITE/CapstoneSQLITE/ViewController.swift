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
    
    let EnteredWellPic: UIImage = UIImage(named: "testimage")!
    let EnteredTankBatteryPic: UIImage = UIImage(named: "testimage")!
    let EnteredLocationPic: UIImage = UIImage(named: "testimage")!
    let EnteredLeaseRoadPic: UIImage = UIImage(named: "testimage")!

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
    
    @IBAction func addPictures(_ sender: Any){
        //change to accomidate inputs
        let wellPI : UIImage = EnteredWellPic
        let wellPD = wellPI.jpegData(compressionQuality: 1)!
        let wellPBase64 = wellPD.base64EncodedString(options: .lineLength64Characters)
        
        let tankBatPI : UIImage = EnteredTankBatteryPic
        let tankBatPD = tankBatPI.jpegData(compressionQuality: 1)!
        let tankBatPBase64 = tankBatPD.base64EncodedString(options: .lineLength64Characters)
        
        let locPI : UIImage = EnteredLocationPic
        let locPD = locPI.jpegData(compressionQuality: 1)!
        let locPBase64 = locPD.base64EncodedString(options: .lineLength64Characters)
        
        let leaseRPI : UIImage = EnteredLeaseRoadPic
        let leaseRPD = leaseRPI.jpegData(compressionQuality: 1)!
        let leaseRPBase64 = leaseRPD.base64EncodedString(options: .lineLength64Characters)
        
        Inspection.addPicture(PicID: 1, PicOfWell: wellPBase64, PicOfTankBattery: tankBatPBase64, PicOfLocation: locPBase64, PicOfLeaseRoad: leaseRPBase64)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        Inspection.delete()
        
    }
    
    @IBAction func listAll(_ sender: Any) {
        Inspection.listInspectionForm()

        Inspection.listWell()
        
        Inspection.listWellImage()
        
        Inspection.listPictures()

    }
    

        
}

