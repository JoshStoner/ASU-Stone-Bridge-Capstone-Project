//
//  InspectionFormViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class InspectionFormViewController: UIViewController {

    var formList:inspectionList?
    
    @IBOutlet weak var wellNameField: UITextField!
    @IBOutlet weak var wellNumberField: UITextField!
    @IBOutlet weak var inspectionDoneField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var spillsField: UITextField!
    @IBOutlet weak var spillsCommentField: UITextField!
    
    @IBOutlet weak var oilField: UITextField!
    @IBOutlet weak var waterField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //code for dismissing keyboard when user taps elsewhere on the view
        let dismissKeyboardTap = UITapGestureRecognizer(target: self.view,
                                                        action: #selector(UIView.endEditing))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    

    @IBAction func saveForm(_ sender: Any)
    {
        let wellName = wellNameField.text
        let wellNumber = Int(wellNumberField.text!)
        let inspectionDone = inspectionDoneField.text
        let date = dateField.text
        
        let spills = spillsField.text
        let spillsComment = spillsCommentField.text
        
        let oilBarrels = Int(oilField.text!)
        let waterBarrels = Int(waterField.text!)
        
        formList?.addForm(da: date!, inspDone: inspectionDone!, weName: wellName!, weNum: wellNumber!, spls: spills!, splsCom: spillsComment!, oil: oilBarrels!, water: waterBarrels!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
