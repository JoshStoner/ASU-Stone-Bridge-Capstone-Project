//
//  InspectionFormViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class InspectionFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate//, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    let defaultImagePickerPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    let testImage = UIImage(systemName: "house")
    var formList:inspectionList?
    let choices = ["", "Yes", "No", "N/A"]
    
    //action types for the image picker, should maybe be an Enum
    //if these get changed here they need to be changed in imageButtonHandler and ImagePicker
    let clearImageAction = "Clear"
    let changeImageAction = "Change Image"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wellNameField: UITextField!
    @IBOutlet weak var wellNumberField: UITextField!
    @IBOutlet weak var inspectionDoneField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var spillsField: UITextField!
    @IBOutlet weak var spillsCommentField: UITextField!
    
    @IBOutlet weak var oilField: UITextField!
    @IBOutlet weak var waterField: UITextField!
    
    //buttons that hold teh picture information
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var pictureButton2: UIButton!
    
    //let imagePicker = UIImagePickerController()
    var spillImagePicker: ImagePicker!
    
    //controls the addition and removal of image buttons when images are added/removed
    private var ibhandler : [ImageButtonHandler] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let spills = UIPickerView()
        spills.delegate = self
        
        spillsField.inputView = spills
        // Do any additional setup after loading the view.
        
        //initiates the image picker used for the spill photo
        self.spillImagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //code for dismissing keyboard when user taps elsewhere on the view
        let dismissKeyboardTap = UITapGestureRecognizer(target: self.view,
                                                        action: #selector(UIView.endEditing))
        view.addGestureRecognizer(dismissKeyboardTap)
        
        //creates the image button handler
        ibhandler.append(ImageButtonHandler(sourceButton: pictureButton, tag: 0))
        ibhandler.append(ImageButtonHandler(sourceButton: pictureButton2, tag: 1))
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

    //Doesn't work on emulator, seems to work on an actual mac
    @IBAction func showImagePicker(_ sender: UIButton){
        /*
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)*/
        self.spillImagePicker.present(from: sender)
    }
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.spillPhoto.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }*/
    
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

//implements what to do when the image is picked
extension InspectionFormViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, action: String, sender: UIButton) {
        
        let buttonHandlerNumber = sender.tag
        
        
        let button = ibhandler[buttonHandlerNumber].handleChange(changedButton: sender, action: action, newImage: image)
        if (button != nil){
            button?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        }
        //view.addSubview(button!)
        /* this part is now just done in the imageButtonHandler
        if (action == clearImageAction) {

            
            //test for making the button change its own background
            // might need to set the image for every state
            sender.setBackgroundImage(defaultImagePickerPhoto, for: .normal);
            
        } else if (action == changeImageAction) {
           
            //test for making the button change its own background
            // might need to set the image for every state
            sender.setBackgroundImage(image, for: .normal);
        }*/
    }
    
}
