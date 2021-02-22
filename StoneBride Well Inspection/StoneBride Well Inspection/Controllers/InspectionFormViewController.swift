//
//  InspectionFormViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import CoreData

class InspectionFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate //, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var iModel:inspectionFormModel?
    
    var load = false // variable used to tell the form to load an already created form rather than make one from scratch
    var loadIndex: IndexPath?
    var loadedCategories: [InspectionFormCategoryEntity]?
    var loadedEnt: InspectionFormEntity?
    var loadedWellName: String?
    var loadedWellNumber: String?
    var loadedInspecDone: String?
    var loadedDate: String?
    
    let defaultImagePickerPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    let testImage = UIImage(systemName: "house")
    var formList:inspectionList?
    let choices = ["", "Yes", "No", "N/A"]
    
    var changed = false // keeps track of if there have been changes since last save
    
    // an array of all the different inspection descriptions
        let inspectionCategoriesNames = ["Pictures of the Well", "Pictures of the Tank Battery", "Pictures of the Location", "Pictures of the Lease Road", "Any Spills to clean up", "Any gas leaks, oil leaks on fittings", "Any leaks around wellhead", "Does any brush need cut", "Does  it need weedeated", "Any trash that needs picked up", "Any erosion occurring", "Are there concrete vaults", "Are there old salt water pits", "Does new ID placement need painted", "Tank Gauges", "Oil BBLS:     WaterBBLS:", "Any electric drops", "Electric Meter Number", "Pump Jack make & Size", "Tubing Size", "# of Tanks and Size", "Plastic Tank/Size", "Oriifce Meter", "Separator", "Electric Motor & Size", "Gasoline Engine and Size", "Electric Line Overhead # of poles", "Concrete Sills", "Fence", "House Gas Meter/with Little Joe/Drip"]
        
    //action types for the image picker, should maybe be an Enum
    //if these get changed here they need to be changed in imageButtonHandler and ImagePicker
    let clearImageAction = "Clear"
    let changeImageAction = "Change Image"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wellNameField: UITextField!
    @IBOutlet weak var wellNumberField: UITextField!
    @IBOutlet weak var inspectionDoneField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    //let imagePicker = UIImagePickerController()
    var spillImagePicker: ImagePicker!
    
    //controls the addition and removal of image buttons when images are added/removed
    private var ibhandler : [ImageButtonHandler] = []
    
    //holds all of the inspection categories
    private var isCategories : [InspectionCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(load)
        
        if(load == true)
        {
            wellNameField.text = loadedWellName
            wellNumberField.text = loadedWellNumber
            inspectionDoneField.text = loadedInspecDone
            dateField.text = loadedDate
        }
        
        //adds the change handler to the fields at the top
        wellNameField.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        wellNumberField.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        inspectionDoneField.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        dateField.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        
        iModel = inspectionFormModel(context: managedObjectContext)
        
        let spills = UIPickerView()
        spills.delegate = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        
        //add a bar style if wanted
        //add a tintColor if wanted
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(InspectionFormViewController.donePressed(sender:)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexButton,doneButton], animated: true)
        
        // these shouldn't be needed anymore
        //spillsField.inputView = spills
        //spillsField.inputAccessoryView = toolbar
        
        // Do any additional setup after loading the view.
        
        //initiates the image picker used for the spill photo
        self.spillImagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //code for dismissing keyboard when user taps elsewhere on the view
        let dismissKeyboardTap = UITapGestureRecognizer(target: self.view,
                                                        action: #selector(UIView.endEditing))
        view.addGestureRecognizer(dismissKeyboardTap)
        
        //creates the image button handler
        /*let tempRect = CGRect()
        let ibHandler1Space = CGRect(x: pictureButton.frame.origin.x, y: pictureButton.frame.origin.y, width: CGFloat(4) * pictureButton.frame.width, height: CGFloat(3) * pictureButton.frame.height)
        ibhandler.append(ImageButtonHandler(sourceButton: pictureButton, tag: 0, numberOfButtons: 7, buttonSpace: ibHandler1Space))
        ibhandler.append(ImageButtonHandler(sourceButton: pictureButton2, tag: 1, numberOfButtons: 3, buttonSpace: tempRect))
    
        
        var point = CGPoint(x: 10, y: 650)
        let isCategory = InspectionCategory(categoryName: "well stuff", topLeftPoint: point, view: oilField.superview!, tagNumber: 2, hasPictures: true, imagePresenter: self)
        
        //isCategory.getSourceButton()?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        //ibhandler.append(isCategory.getImageButtonHandler()!)
        //isCategory.getData()
        isCategories.append(isCategory)*/
        
        //adds all of the inspection categories to the document
        var point = CGPoint(x:10, y: 210)
        
        //creates a new form if load is false
        if (load == false) {
            for i in 0..<inspectionCategoriesNames.count
            {
                if i < 4
                {
                    isCategories.append(InspectionCategory(categoryName: inspectionCategoriesNames[i], topLeftPoint: point, view: wellNameField.superview!, tagNumber: /*3 + */i, editable: true, hasPictures: true, numberOfPictures: 4,  imagePresenter: self))
                point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                    
                }
                else
                {
                    isCategories.append(InspectionCategory(categoryName: inspectionCategoriesNames[i], topLeftPoint: point, view: wellNameField.superview!, tagNumber: /*3 + */i, editable: true, hasPictures: false, numberOfPictures: 0,  imagePresenter: self))
                    point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                }
            }
        }
        //loads an saved form if load is true
        else {
            //adds all of the inspection categories to the document
            var i = 0
            var point = CGPoint(x:10, y: 210)
            let ifCategory = loadedCategories
            while i < 30
            {
            
                if i < 4
                {
                    var images: [UIImage] = []
                    
                    if (ifCategory![i].category?.pictureData?.hasPics == true)
                    {
                        let savedPicEnt = (ifCategory![i].category?.pictureData?.pic?.allObjects as! [InspectionFormPicturesEntity]).sorted(by: {$0.picTag < $1.picTag})
                        
                        //print("Before")
                        //print(savedPicEnt.count)
                        //print(savedPicEnt[i].picTag)
                        //print("AFTER")
                        
                        var j = i
                        //print("In loop")
                        while j < savedPicEnt.count
                        {
                            //print(savedPicEnt[j].picData)
                            let img = savedPicEnt[j].picData!
                            let saveImage = UIImage(data: img)
                            //images.insert(saveImage!, at: j) // this didn't work for me when there was more than one image saved but below did - Josh
                            images.append(saveImage!)
                            //print("images.count = \(images.count)")
                            //print("Added an img to images")
                            //print("j = \(j)")
                            //print("images.count = \(images.count)")
                            //print("images = \(images)")
                            j += 1
                        }
                        //print("Out of loop")
                        //print("images.count = \(images.count)")
                        //print("images = \(images)")
                        let categoryName = inspectionCategoriesNames[i]
                        let comment = ifCategory![i].category?.optComm ?? ""
                        let applicable = ifCategory![i].category?.ynAns ?? ""
                        let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                        isCategories.append(InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: wellNameField.superview!, tagNumber: i, editable: true, hasPictures: true, numberOfPictures: 4,  imagePresenter: self))
                    }
                    //print(i)
                    point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                    
                }
                else
                {
                    let images: [UIImage] = []
                    let categoryName = inspectionCategoriesNames[i]
                    let comment = ifCategory![i].category?.optComm ?? ""
                    let applicable = ifCategory![i].category?.ynAns ?? ""
                    let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                    isCategories.append(InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: wellNameField.superview!, tagNumber: i, editable: true, hasPictures: false, numberOfPictures: 0,  imagePresenter: self))
                    point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                }
                i += 1
            }
            
        }
        
        //print(point.y)
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
        //spillsField.text = choices[row]
    }
    
    @objc func donePressed(sender: UIBarButtonItem)
    {
        //spillsField.resignFirstResponder()
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
        var wellName = ""
        var wellNumber = -1
        var inspectionDone = ""
        var date = ""
        
        var spills = ""
        var spillsComment = ""
        
        var oilBarrels = -1
        var waterBarrels = -1
        
        if wellNameField.hasText == true
        {
            wellName = wellNameField.text!
        }
        if wellNumberField.hasText == true
        {
            wellNumber = Int(wellNumberField.text!)!
        }
        if inspectionDoneField.hasText == true
        {
            inspectionDone = inspectionDoneField.text!
        }
        if dateField.hasText
        {
            date = dateField.text!
        }
        /*
        if spillsField.hasText == true
        {
            spills = spillsField.text!
        }
        if spillsCommentField.hasText == true
        {
            spillsComment = spillsCommentField.text!
        }
        
        if oilField.hasText == true
        {
            oilBarrels = Int(oilField.text!)!
        }
        if waterField.hasText == true
        {
            waterBarrels = Int(waterField.text!)!
        }
        */
        //formList?.addForm(da: date!, inspDone: inspectionDone!, weName: wellName!, weNum: wellNumber!, spls: spills!, splsCom: spillsComment!, oil: oilBarrels!, water: waterBarrels!)*/
        
        if (load == false)
        {
            iModel?.saveContext(d: date, inspecDone: inspectionDone, wName: wellName, wNum: wellNumber, spilToClean: spills, spilToCleanComm: spillsComment, oBarrels: oilBarrels, wBarrels: waterBarrels, categories: isCategories)
        }
        else
        {
            iModel?.updateContext(contextObject: loadedEnt!, d: date, inspecDone: inspectionDone, wName: wellName, wNum: wellNumber, spilToClean: spills, spilToCleanComm: spillsComment, oBarrels: oilBarrels, wBarrels: waterBarrels, categories: isCategories)
        }
        
        //updates all teh categories to let them know it has been saved
        for category in isCategories
        {
            category.changed = false
        }
        changed = false
        
        /*var i = 0
        while i < 30
        {
            print(isCategories[i].tag)
            i += 1
        }*/
    }
    
    //this function determines if all necessary parts of the inspection categories are complete
    //it returns the index of all incomplete categories
    func areCategoriesComplete() -> Bool
    {
        var allComplete = true
        for category in isCategories {
            if (category.isEdited() == false)
            {
                allComplete = false
                category.highlightUnedited()
            }
        }
        
        return allComplete
    }
    
    //this function determines if all the necessary parts of the form are completed, currently this is just the four parts at the top of the form and the YN for all the categories
    //if parts of the form aren't complete it highlights them
    func isFormComplete() -> Bool
    {
        var complete = true
        
        
        //checks the text fields at the top of the form
        if (wellNameField.text == "")
        {
            complete = false
            wellNameField.backgroundColor = .red
        }
        
        //makes sure well number field is a number
        if (wellNumberField.text == "" || (Int(wellNumberField.text!) ?? -1) == -1)
        {
            complete = false
            wellNumberField.backgroundColor = .red
        }
        
        if (inspectionDoneField.text == "")
        {
            complete = false
            inspectionDoneField.backgroundColor = .red
        }
        
        if (dateField.text == "")
        {
            complete = false
            dateField.backgroundColor = .red
        }
        
        if (areCategoriesComplete() == false)
        {
            complete = false
        }
        
        
        return complete
        
    }
    
    //this function determines if all necessary parts of the form are complete and then pushes it to the server if they are connected to the internet
    //if the form is not complete it will highlight the missing parts
    //if they are not connected to the internet it will tell them
    @IBAction func publishForm(_ sender: Any) {
        let formComplete = isFormComplete()
        
        if (formComplete == false)
        {
            //sends an alert to the user that some information is incomplete
            // in the future this could be put in the isFormComplete function and send a more specific alert
            let alert = UIAlertController(title: "Form Incomplete", message: "Please fill out and/or fix the highlighted fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //check internet connection UNIMPLIMENTED
        
        
        //make connection to database this will probably need something to prevent the user from changing views
        
        //send form to data base
        //performSegue(withIdentifier: "FormToTable", sender: nil)
    }
    
    
    func hasFormChanged() -> Bool
    {
        //checks if any of the text fields at the top have been changed
        if (changed == true)
        {
            return true
        }
        
        
        //checks if any of the categories have been changed
        for category in isCategories
        {
            if (category.changed == true)
            {
                return true
            }
        }
        
        return false
        
    }
    
    
    @IBAction func fieldChanged(_ sender: Any)
    {
        changed = true
    }
    
    //used by the text fields to change their backgroundColor back to clear if they have been edited
    @IBAction func changeBackgroundColor(_ sender: UITextField) {
        if (sender.text != "")
        {
            sender.backgroundColor = .clear
        }
    }
    
    func determineSegue()
    {
        if (load == true)
        {
            performSegue(withIdentifier: "FormToTable", sender: self)
        } else{
            performSegue(withIdentifier: "FormToMenu", sender: self)
        }    }
    
    //this function handles the logic for the back button
    @IBAction func unwindSegue(_ sender: Any)
    {
        //first step is to check if anything has changed
        if (hasFormChanged())
        {
            //do alert the user that stuff is unsaved
            
            let alert = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to leave? Unsaved changes will be lost", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
            //this action segues if the user confrims
            alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: {(_) -> () in self.determineSegue()}))
            self.present(alert, animated: true, completion: nil)
        } else
        {
            //decide which unwind segue to use
            determineSegue()
        }
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
