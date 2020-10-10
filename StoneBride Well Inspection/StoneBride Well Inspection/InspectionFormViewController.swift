//
//  InspectionFormViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class InspectionFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{

    var formList:inspectionList?
    let choices = ["", "Yes", "No", "N/A"]
    
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

        let spills = UIPickerView()
        spills.delegate = self
        
        spillsField.inputView = spills
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        spillsField.text = choices[row]
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
