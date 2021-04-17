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
    var DB = Database()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var iModel:inspectionFormModel?
    
    var alreadySaved = false
    var load = false // variable used to tell the form to load an already created form rather than make one from scratch
    var loadIndex: IndexPath?
    var loadedCategories: [InspectionFormCategoryEntity]?
    var loadedEnt: InspectionFormEntity?
    var loadedWellName: String?
    var loadedWellNumber: String?
    var loadedInspecDone: String?
    var loadedDate: String?
    var InspectionFound: Bool = false;
    let defaultImagePickerPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    let testImage = UIImage(systemName: "house")
    //var formList:inspectionList?
    let choices = ["", "Yes", "No", "N/A"]
    
    var changed = false // keeps track of if there have been changes since last save
    
    let inspectionCategoriesNames = ["Pictures of the Lease Road", "Pictures of the Tank Battery", "Are there concrete vaults", "Are there old salt water pits", "Does it need new ID/repaint", "Tank Gauges", "Oil BBLS:     Water BBLS:", "# of Tanks and Size", "Plastic Tank/Size", "Orifice Meter", "Separator", "House Gas Meter/with Little Joe/Drip", "Pictures of the Well", "Pump Jack Make & Size", "Tubing Size", "Electric Motor & Size", "Gasoline Engine & Size", "Concrete Sills", "Any leaks around Wellhead", "Pictures of the Well Location", "Any spills to clean up", "Any gas leaks, oil leaks on fittings", "Does any brush need cut", "Does it need weedeated", "Any trash that needs picked up", "Any erosion occuring", "Any electric drops", "Electric Meter Number", "Electric Line overhead # of poles", "Fence"]
    
    // an array of all the different inspection descriptions
       // let inspectionCategoriesNames = ["Pictures of the Well", "Pictures of the Tank Battery", "Pictures of the Location", "Pictures of the Lease Road", "Any Spills to clean up", "Any gas leaks, oil leaks on fittings", "Any leaks around wellhead", "Does any brush need cut", "Does  it need weedeated", "Any trash that needs picked up", "Any erosion occurring", "Are there concrete vaults", "Are there old salt water pits", "Does new ID placement need painted", "Tank Gauges", "Oil BBLS:     WaterBBLS:", "Any electric drops", "Electric Meter Number", "Pump Jack make & Size", "Tubing Size", "# of Tanks and Size", "Plastic Tank/Size", "Oriifce Meter", "Separator", "Electric Motor & Size", "Gasoline Engine and Size", "Electric Line Overhead # of poles", "Concrete Sills", "Fence", "House Gas Meter/with Little Joe/Drip"]
        
    //action types for the image picker, should maybe be an Enum
    //if these get changed here they need to be changed in imageButtonHandler and ImagePicker
    let clearImageAction = "Clear"
    let changeImageAction = "Change Image"
    
    //scroll view is the scrollview for the page, main view is the view inside of the scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
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
    
    /*struct categoryButton
    {
        var categoryTag: Int
        var buttons: [UIButton]
    }*/
    
    //Used to change the scrollView height but needs to implemented differently. This height is for the height of the entire page. We need a different function for adding new buttons into the page to shift everything below a specific y height down whatever the height of the button is.
    @IBOutlet weak var uiViewHeight: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        //sets the initial height of the scroll view
        mainView.sizeToFit()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: mainView.frame.height)
        increasePageLength()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(load)
        //print("The count of s is \(s.count)")
        DB.DatabaseConnection()
        
        DB.createInspectionFormTable()
        DB.createPictureTable()
        DB.createInspectionDescriptionTable()
        
        if(load == true)
        {
            wellNameField.text = loadedWellName
            wellNumberField.text = loadedWellNumber
            inspectionDoneField.text = loadedInspecDone
            dateField.text = loadedDate
        } else
        {
            //sets up the date to be the current day
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateField.text = dateFormatter.string(from: date)
            
            //autofill the inspectionDoneField to be the name of the user who has logged in COMPLETE LATER
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
                if i < 30//4
                {
                    isCategories.append(InspectionCategory(categoryName: inspectionCategoriesNames[i], topLeftPoint: point, view: wellNameField.superview!, tagNumber: i, editable: true, hasPictures: true, numberOfPictures: 20/*4*/,  imagePresenter: self))
                    isCategories[i].setViewController(vc: self)
                point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                    
                }
                else
                {
                    isCategories.append(InspectionCategory(categoryName: inspectionCategoriesNames[i], topLeftPoint: point, view: wellNameField.superview!, tagNumber: i, editable: true, hasPictures: false, numberOfPictures: 0,  imagePresenter: self))
                    isCategories[i].setViewController(vc: self)
                    point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                }
            }
        }
        //loads an saved form if load is true
        else {
            //adds all of the inspection categories to the document
            var i = 0
            //var point = CGPoint(x:10, y: 210)
            let ifCategory = loadedCategories
            while i < 30
            {
            
                if i < 30//4
                {
                    //var catButtons: [categoryButton] = []
                    var images: [UIImage] = []
                    var urls: [String] = []
                    
                    if (ifCategory![i].category?.pictureData?.hasPics == true)
                    {
                        let savedPicEnt = (ifCategory![i].category?.pictureData?.pic?.allObjects as! [InspectionFormPicturesEntity]).sorted(by: {$0.picTag < $1.picTag})
                        
                        
                        
                        //print("Before")
                        //print(savedPicEnt.count)
                        //print(savedPicEnt[i].picTag)
                        //print("AFTER")
                        
                        var j = 0 //changed from i to 0
                        //print("In loop")
                        //print("the count is \(savedPicEnt.count)")
                        while j < savedPicEnt.count
                        {
                            //print("loaded a picture, j is \(j)")
                            //print(savedPicEnt[j].picData)
                            //print(Int(savedPicEnt[j].picTag))
                            let img = savedPicEnt[j].picData!
                            let saveImage = UIImage(data: img)
                            //images.insert(saveImage!, at: j) // this didn't work for me when there was more than one image saved but below did - Josh
                            images.append(saveImage!)
                            urls.append(savedPicEnt[j].picURL!)
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
                        let inspecCategoryStuff = InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: wellNameField.superview!, tagNumber: i, editable: true, hasPictures: true, numberOfPictures: 20, loadedURLS: urls,  imagePresenter: self)
                        inspecCategoryStuff.setViewController(vc: self)
                        isCategories.append(inspecCategoryStuff)
                        
                        let b = isCategories[i].inspectionPictures
                        ibhandler.append(b!)
                        //Need to update the ibhandler for all buttons in the categories
                        //Currently have every button with each category it goes to
                        //catButtons.append(categoryButton(categoryTag: i, buttons: inspecCategoryStuff.buttons))
                        
                        /*j = 0
                        //Might need to mess with this rect a bit
                        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
                        print("images.count is \(images.count)")
                        while(j < images.count)
                        {
                            
                            //let b = ImageButtonHandler(sourceButton: catButtons[i].buttons[j], tag: j, numberOfButtons: images.count, buttonSpace: rect)
                            ibhandler.append(b!)
                            j += 1
                        }*/
                        
                        //This part is specifically for when the user wants to add a new image to the category
                        //Meaning the new image should be in a button and that button should have an ImageButtonHandler
                        //Need to create an extra button for every category that has less than 5 pictures
                        //if(saved.PicEnt.count < 5)
                        //{
                            //Next need the create an ImageButtonHandler for the extra button
                            //Then need to save ibhandler.append(new ImageButtonHandler)
                        //}
                        
                        /*j = 0
                        var k = 0
                        print("Showing the tag numbers for each button")
                        while(j < ibhandler.count)
                        {
                            //This should get all buttons in the ibhandler at position j
                            let testing = ibhandler[j].getButtons()
                            print("testing.count is \(testing.count)")
                            k = 0
                            while(k < testing.count)
                            {
                                //This should print every button's tag
                                print("For the button at element \(j) the tags are \(testing[k].tag)")
                                k += 1
                            }
                            j += 1
                        }*/
                        
                    }
                    //print(i)
                    //point.y += CGFloat(isCategories[i].getHeight() + 10)
                    point.y += CGFloat(isCategories[i].projectedHeight(numberOfImages: images.count, readOnly: false) + 10)
                }
                else
                {
                    /*let images: [UIImage] = []
                    let categoryName = inspectionCategoriesNames[i]
                    let comment = ifCategory![i].category?.optComm ?? ""
                    let applicable = ifCategory![i].category?.ynAns ?? ""
                    let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                    let inspecCategoryStuff = InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: wellNameField.superview!, tagNumber: i, editable: true, hasPictures: false, numberOfPictures: 0,  imagePresenter: self)
                    inspecCategoryStuff.setViewController(vc: self)
                    isCategories.append(inspecCategoryStuff)
                    point.y += CGFloat(isCategories[i].getHeight() + 10)*/
                    
                }
                i += 1
            }
            
            /*var j = 0
            var k = 0
            print("Showing the tag numbers for each button")
            while(j < ibhandler.count)
            {
                //This should get all buttons in the ibhandler at position j
                let testing = ibhandler[j].getButtons()
                print("testing.count is \(testing.count)")
                k = 0
                while(k < testing.count)
                {
                    //This should print every button's tag
                    print("For the button at element \(j) the tags are \(testing[k].tag)")
                    k += 1
                }
                j += 1
            }*/
            
        }
        //print("got here")
        //sets the scroll views height to the total height of the UI elements plus a little bit
        mainView.frame = CGRect(x: 0, y: 0, width: mainView.frame.minX, height: point.y + 100)
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: point.y)
        
        
        
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
        
        if (load == false && alreadySaved == false)
        {
            loadedEnt = iModel?.saveContext(d: date, inspecDone: inspectionDone, wName: wellName, wNum: wellNumber,  categories: isCategories)
            //loadedEnt = iModel?.searchEnt(sWellName: wellName, sDate: date, sWellNumber: wellNumber, sInspectionDone: inspectionDone)
            if loadedEnt != nil
            {
                alreadySaved = true
            }
        }
        else
        {
            iModel?.updateContext(contextObject: loadedEnt!, d: date, inspecDone: inspectionDone, wName: wellName, wNum: wellNumber, categories: isCategories)
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
        }else{
        
        //check internet connection UNIMPLIMENTED
        
        
        //make connection to database this will probably need something to prevent the user from changing views
        //
        //send form to data base
        saveForm((Any).self)
        if (alreadySaved == true || load == true)//(load == false)
        {
            let InspectionFormData = loadedEnt
            
            if (InspectionFormData == nil)
            {
               print("SeachedEnt failed")
            }else
            {
                print("SeachedEnt success")
//                print(InspectionFormData?.wellName! as Any)
//                print(InspectionFormData?.date! as Any)
//                print(InspectionFormData?.wellNumber as Any)
//                print(InspectionFormData?.inspectionDone as Any)
                
                InspectionFound = DB.searchInspectionForm(wellID: Int(InspectionFormData!.wellNumber), wellName: InspectionFormData!.wellName!, Date: InspectionFormData!.date!)
                
                if(InspectionFound == true)
                {
                    print("Inspection Form already exists")
                    DB.listInspectionForm()

                }else{
                    
                    print("Inspection Form doesn't exists")
                    DB.addInspection(wellID: Int(InspectionFormData!.wellNumber), wellName: InspectionFormData!.wellName!, date: InspectionFormData!.date!, employeeName: InspectionFormData!.inspectionDone!)
                    DB.listInspectionForm()

                }
                
                // Sort the contextObject.Section
                let sortSections = InspectionFormData?.section
                
                let sortedSections = (sortSections?.allObjects as! [InspectionFormCategoryEntity]).sorted(by: {$0.tagN < $1.tagN})
                var i = 0;
                var pictureCount = 0;
                while i < 30
                {
                    if(i < 30)
                    {
                        // Move this line up here to update Pictures
                        let categoryName = inspectionCategoriesNames[i]

                        // Contains all the pictures under a category
                        if(sortedSections[i].category?.pictureData?.hasPics == true)
                        {
                            let savedPicEnt = (sortedSections[i].category?.pictureData?.pic?.allObjects as! [InspectionFormPicturesEntity]).sorted(by: {$0.picTag < $1.picTag})
                            var j = 0;
                            
                            while j < savedPicEnt.count
                            {
                                let img = savedPicEnt[j].picData!
                                // Coverting it to UIImage and saving it into saveImage variabe
                                let saveImage = UIImage(data: img)
                                //is it supposed to be i or j here?
                                // charID relates to the category so i for that one.
                                if(InspectionFound == true)
                                {
                                    DB.deletePictures(wellID: Int(InspectionFormData!.wellNumber), Category: categoryName, PicID: pictureCount + 1, charID: i + 1, image: saveImage!)
                                    DB.addPicture(PicID: pictureCount+1 ,image: saveImage!, charID: i+1, wellID: Int(InspectionFormData!.wellNumber), date: InspectionFormData!.date!)
                                }else
                                {
                                    
                                    DB.addPicture(PicID: pictureCount+1 ,image: saveImage!, charID: i+1, wellID: Int(InspectionFormData!.wellNumber), date: InspectionFormData!.date!)
                                }
                                pictureCount += 1;
                                j += 1;
                            }
                            //if the form has the default comment then it replaces it with the defaultCommentReplacement when viewing the form
                            let comment = sortedSections[i].category?.optComm ?? ""
                            
                            let applicable = sortedSections[i].category?.ynAns ?? ""
                            
                            if(InspectionFound == true)
                            {
                                DB.updateInspectionForm(wellID: Int(InspectionFormData!.wellNumber), Comments: comment, YesorNo: applicable, Category: categoryName)
                            }else{
                                DB.addWell(wellID: Int(InspectionFormData!.wellNumber), Category: categoryName, YesOrNo: applicable, comment: comment, charID: i+1, date: InspectionFormData!.date!)
                            }
                          
                        }
                    }
                    i += 1;
                }
            
                DB.listWell()
                DB.listPictures()
                
//                call for converting to csv
                //wName: InspectionFormData!.wellName!, wIDate: InspectionFormData!.date!
                DB.convertToCSV()
                
                
                print("Done publishing!")
            }
        
            
            
        }
        }
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
            deleteStuff()
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "FormToTable", sender: self)
        }
        else
        {
            deleteStuff()
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "FormToMenu", sender: self)
        }
    }
    
    func deleteStuff()
    {
        
        iModel = nil
        
        loadIndex = nil
        loadedCategories = nil
        loadedEnt = nil
        loadedWellName = nil
        loadedWellNumber = nil
        loadedInspecDone = nil
        loadedDate = nil
        
        //controls the addition and removal of image buttons when images are added/removed
        ibhandler = []
        
        //holds all of the inspection categories
        isCategories = []
        
        print("Stuff deleted from InspectionFormViewController")
    }
    
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
    
    func increasePageLength()
    {
        
        var maxHeight : CGFloat = 0
        var test : CGFloat = 0
        for view in self.scrollView.subviews
        {
            for subView in view.subviews
            {
                let t = subView.frame.origin.y + subView.frame.height
                if t > test
                {
                    test = t
                }
            }
            let newHeight = view.frame.origin.y + view.frame.height
            //print(subView.frame.origin.y)
            if newHeight > maxHeight
            {
                maxHeight = newHeight
            }
        
        //print(maxHeight)
        //print(test)
        //print(scrollView.contentSize.height)
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 12000.0)
            uiViewHeight.constant = test + 50.0
            scrollView.subviews[0].layoutIfNeeded()
            scrollView.subviews[0].frame = CGRect(x: 0, y: 0, width: scrollView.subviews[0].frame.width, height: test + 50.0)
            
            //scrollView.subviews[0].sizeToFit()
            //scrollView.subviews[0].frame.height = test + 50.0
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: test + 50.0)
        }
        //print(scrollView.contentSize.height)
        //print(scrollView.subviews[0].frame.height)
    }
    
    public func shiftCategories(tag: Int, amount: Int)
    {
        //print("Shifting categories with a tag id of \(tag+1) and greater")
        //shifts all of the categories that come after the one that got changed
        var i = tag + 1
        while (i < isCategories.count)
        {
            isCategories[i].shiftHappened()
            isCategories[i].shiftVertically(amount: amount)
            
            
            i += 1
        }
        
        //adjusts the scroll view to fit everything properly
        mainView.frame = CGRect(x: mainView.frame.minX, y: mainView.frame.minY, width: mainView.frame.width, height: mainView.frame.height + CGFloat(amount))
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: mainView.frame.height)
        //print(mainView.frame.height)
        
        increasePageLength()
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
    
    func didSelect(image: UIImage?, imageURL: String, action: String, sender: UIButton) {
        let buttonHandlerNumber = sender.tag
        print("Inside InspectionFormViewController")
        
        guard let url = URL(string: imageURL)
        else
        {
            print("oh no thats no URL")
            return
        }
        let data = try? Data(contentsOf: url)
        if let imageData = data
        {
            let urlImage = UIImage(data: imageData)
            print("urlImage!!!!!!!!!!")
            print(urlImage)
        }
        //print("imageURL for selected image is \(imageURL)")
        print("image!!!!!!!!!!!!!!!!")
        print(image)
        //print("buttonHandlerNumber is \(buttonHandlerNumber)")
        //Currently I think every button tag number is not updating meaning every button tag number is 0
        //So this will replace the very first button handler in the ibhandler but will change the correct button's
        //information in the handleChange function
        //Also we need to find either a new way to hold the ImageButtonHandlers because the button tag id should
        //all be in a range like 0 to 5 for four different categories
        var i = 0
        var j = 0
        var found = false
        while (i < ibhandler.count)
        {
            j = 0
            while (j < ibhandler[i].buttons.count)
            {
                if ibhandler[i].buttons[j].tag == buttonHandlerNumber
                {
                    found = true
                    break
                }
                j += 1
            }
            if (found == true)
            {
                break
            }
            i += 1
        }
        let changedButton = ibhandler[i].handleChange(changedButton: ibhandler[i].buttons[j], action: action, newImage: image, imageURL: imageURL)
        ibhandler[i].urls[j] = imageURL
        isCategories[i].updateURLS(index: i, newURL: imageURL)
        increasePageLength()
        
        /*let button = ibhandler[buttonHandlerNumber].handleChange(changedButton: sender, action: action, newImage: image)
        if (button != nil){
            button?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        }*/
        
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
