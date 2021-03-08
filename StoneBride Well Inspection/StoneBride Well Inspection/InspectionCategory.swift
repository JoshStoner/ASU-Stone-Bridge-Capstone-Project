//
//  InspectionCategory.swift
//  StoneBride Well Inspection
//
//  Created by Joshua on 11/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//
//this class is used to create all of the UI elements needed for a single inspection category on the inspection form

import UIKit

class InspectionCategory: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, ImagePickerDelegate
{
    var inspectionLabel : UILabel
    var inspectionComment : UITextView
    var inspectionPictures : ImageButtonHandler?
    var inspectionYNField : UITextField? // used when editable
    var inspectionYNLabel : UILabel? // used when not editable
    
    let defaultComment : String = "Add optional comment"// the placeholder text for the comment
    var tag : Int  // the tag that all of the elements will have
    var height : Double //total height of the rectangle that the elements use
    var width : Double //total width of the rectangle that the elements use
    var hasPictures : Bool // whether or not this category has pictures
    var imagePicker : ImagePicker? //needed to present the image picker
    var editable: Bool = true // whether or not the category can be edited
    var inspectionPicturesSourceButton : UIButton?
    var changed = false
    
    //the font that gets used for the textView
    var textViewFont: UIFont = UIFont(name: "Verdana", size: 16.0)!
    
    let defaultPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    
    
    let choices = ["", "Yes", "No", "N/A"] // options that can be chosen in the picker view
    
    public init(categoryName: String, topLeftPoint: CGPoint, view: UIView, tagNumber: Int, editable: Bool, hasPictures: Bool, numberOfPictures: Int,  imagePresenter: UIViewController)
    {
        self.hasPictures = hasPictures
        self.editable = editable
        tag = tagNumber
        //initializes all the parts of an inspection category
        
        //initializes the inspection label
        let inspectionLabelSize = CGSize(width: 330, height: 20)
        
        inspectionLabel = UILabel(frame: CGRect(origin: topLeftPoint, size: inspectionLabelSize))
        //setting the font to be bold with a size of 18
        let boldFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let boldText = NSMutableAttributedString(string: categoryName, attributes: boldFont)
        
        inspectionLabel.attributedText = boldText//categoryName
        inspectionLabel.tag = tag
        
        
        //initializes the YN text field
        let inspectionLabelYNSize = CGSize(width: 97, height: 34)
        if (editable){
            inspectionYNField = UITextField(frame: CGRect(x: topLeftPoint.x, y: topLeftPoint.y+30, width: inspectionLabelYNSize.width, height: inspectionLabelYNSize.height))
            inspectionYNField!.tag = tag
            inspectionYNField!.borderStyle = .bezel
            inspectionYNField!.text = ""
        } else {
            inspectionYNLabel = UILabel(frame: CGRect(x: topLeftPoint.x, y: topLeftPoint.y+30, width: inspectionLabelYNSize.width, height: inspectionLabelYNSize.height))
            inspectionYNLabel!.tag = tag
            inspectionYNLabel!.text = ""
        }
        
        //initializes the comment
        let InspectionCommentFrameWidth = 200 + 10 + inspectionLabelYNSize.width
        let inspectionCommentFrame = CGRect(x: topLeftPoint.x, y: topLeftPoint.y + inspectionLabelSize.height + 50, width: InspectionCommentFrameWidth, height: 100)
        inspectionComment = UITextView(frame: inspectionCommentFrame)
        inspectionComment.text = defaultComment;
        inspectionComment.isEditable = self.editable
        inspectionComment.font = textViewFont
        inspectionComment.textColor = UIColor.darkGray
        inspectionComment.layer.borderColor = UIColor.lightGray.cgColor
        inspectionComment.layer.borderWidth = 1
        inspectionComment.tag = tag
        //inspectionComment.borderStyle = .bezel
        
        //adds all of the UI elements to the view
        view.addSubview(inspectionLabel)
        view.addSubview(inspectionComment)
        if (self.editable){
            view.addSubview(inspectionYNField!)
        } else
        {
            view.addSubview(inspectionYNLabel!)
        }
        
        
        
        height = -1
      
        width = inspectionCommentFrame.width.native
        
        
        super.init()
        
        inspectionComment.delegate = self
        
        let pullDown = UIPickerView()
        pullDown.delegate = self
        pullDown.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //add a bar style if wanted
        //add a tintColor if wanted
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(InspectionFormViewController.donePressed(sender:)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexButton, doneButton], animated: true)
        
        if (self.editable) {
        inspectionYNField!.inputView = pullDown
        inspectionYNField!.inputAccessoryView = toolbar
        }
        
        //initializes the picture related variables
        if (hasPictures && numberOfPictures > 0) {
            
            imagePicker = ImagePicker(presentationController: imagePresenter, delegate: self)
            
            //creates the original picture button
            let pictureFrame = CGRect(x: topLeftPoint.x, y: inspectionCommentFrame.maxY + 10, width: InspectionCommentFrameWidth, height: 100)
            inspectionPicturesSourceButton = UIButton(frame: CGRect(x: topLeftPoint.x, y: pictureFrame.minY, width: 80, height: 60))
            inspectionPicturesSourceButton?.tag = tag*4
            inspectionPicturesSourceButton?.setBackgroundImage(defaultPhoto, for: .normal)
            
            if (self.editable) { // only adds the action to add another picture if it is editable
                inspectionPicturesSourceButton?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
            }
            inspectionPictures = ImageButtonHandler(sourceButton: inspectionPicturesSourceButton!, tag: tag, numberOfButtons: numberOfPictures, buttonSpace: pictureFrame)
            
            //calculates height including pictures
            height = pictureFrame.maxY.native - topLeftPoint.y.native
            
            //adds the button to the view
            view.addSubview(inspectionPicturesSourceButton!)
            
            
            
        } else {
            inspectionPictures = nil
            
            //calculates height not including pictures
            height = inspectionCommentFrame.maxY.native - topLeftPoint.y.native + 20
        }
    }
    
    //creates and returns an inspection category given a set of inspection category data and necessary information
    public static func loadInspectionCategory(data: InspectionCategoryData, topLeftPoint: CGPoint, view: UIView, tagNumber: Int, editable: Bool, hasPictures: Bool, numberOfPictures: Int, imagePresenter: UIViewController) -> InspectionCategory
    {
        //var buttonArr: [UIButton] = []
        let isCategory = InspectionCategory(categoryName: data.categoryName, topLeftPoint: topLeftPoint, view: view, tagNumber: tagNumber, editable: editable, hasPictures: hasPictures, numberOfPictures: numberOfPictures, imagePresenter: imagePresenter)
        
        //sets all of the text fields to the values in the Inspection Category data
        isCategory.inspectionComment.text = data.comment
        if (data.comment != isCategory.defaultComment || editable == false)
        {
            isCategory.inspectionComment.textColor = UIColor.black
        }
        
        
        
        if (editable) {
            isCategory.inspectionYNField!.text = data.applicable
            
        } else {
            isCategory.inspectionYNLabel!.text = data.applicable
        }
        //checks if there are pictures
        if (hasPictures && data.images.count > 0)
        {
            
            //adds all of the pictures to the category
            for i in 0..<data.images.count
            {
                /*
                var button = isCategory.inspectionPictures?.addImage(image: data.images[i])
                
                if (editable )// && button != nil)
                {
                    
                  button?.addTarget(self, action: #selector(testFunc), for: .touchUpInside)
                }*/
                
                let button = isCategory.inspectionPictures!.handleChange(changedButton: isCategory.inspectionPictures!.buttons[isCategory.inspectionPictures!.buttons.count-1], action: "Change Image", newImage: data.images[i])
                if (button != nil && editable == true){
                    //print("Adding the new image")
                    button?.addTarget(imagePresenter, action: #selector(showImagePicker(_:)), for: .touchUpInside)
                    //buttonArr.append(button!)
                    //print("New Image added")
                }
                
                //I tried this for adding the extra ImageButtonHandler for the extra empty button but the button is
                //always nil
                /*if(data.images.count < 5)
                {
                    var button = isCategory.inspectionPictures?.addImage(image: UIImage(systemName:"plus.rectangle.on.folder")!)
                    if(editable && button != nil)
                    {
                        print("Added extra button")
                        button?.addTarget(imagePresenter, action: #selector(showImagePicker(_:)), for: .touchUpInside)
                        buttonArr.append(button!)
                    }
                }*/
                
            }
            
            
        }
        //let a = InspectionCategoryStuff(categories: isCategory, buttons: buttonArr)
        return isCategory
    }
    
    public func getTag() -> Int
    {
        return tag
    }
    
    public func getWidth() -> Double
    {
        return width
    }
    
    public func getHeight() -> Double
    {
        return height
    }

    public func getSourceButton() -> UIButton?
    {
        return inspectionPicturesSourceButton
    }
    
    public func getImageButtonHandler() -> ImageButtonHandler?
    {
        return inspectionPictures
    }
    
    public func getImages() -> [UIImage]
    {
        var images: [UIImage] = []
        if (hasPictures)
        {
            images = inspectionPictures!.getImages()
        }
        return images
    }
    
    public func getData() -> InspectionCategoryData
    {
        let category = inspectionLabel.text
        let images = getImages()
        let comment = inspectionComment.text
        var applicable = ""
        if (self.editable) {
            applicable = inspectionYNField!.text ?? ""
        } else {
            applicable = inspectionYNLabel!.text ?? ""
        }
        let data = InspectionCategoryData(categoryName: category ?? "", images: images, comment: comment ?? "", applicable: applicable)
        return data
    }
    
    //returns true if the necessary fields have been edited, currently that is just the YN field
    //the formatting of this function should be very similar to the highlight function
    func isEdited() -> Bool
    {
        if (self.editable && inspectionYNField!.text != "")
        {
            return true
        }
        return false
    }
    
    //this function highlights necessary fields in this inspection category taht haven't been filled out
    func highlightUnedited()
    {
        if (self.editable && inspectionYNField!.text == "")
        {
            inspectionYNField?.backgroundColor = .red
        }
    }
    
    
    //functions for the picker view compatability
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
    
    // this function might need to have the force unwrap be contained inside a check for editable, but I'm not sure
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //checks to see if the text changed
        if (inspectionYNField!.text != choices[row])
        {
            changed = true
        }
        
        inspectionYNField!.text = choices[row]
        //changes the color of the background to clear to indicate that it has been edited
        if (inspectionYNField!.text != "")
        {
            inspectionYNField?.backgroundColor = .clear
        }
    }
    
    @objc func donePressed(sender: UIBarButtonItem)
    {
        inspectionYNField!.resignFirstResponder()
    }
    /*
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent: Int) -> CGFloat
    {
    return 60
    }
 */
    
    //functions required for the imageButtonHandler
    
    //Doesn't work on emulator, seems to work on an actual mac
    @IBAction func showImagePicker(_ sender: UIButton){
        /*
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)*/
        imagePicker?.present(from: sender)
        
    }
    
    @objc func showImagePicker2(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @objc func testFunc()
    {
        print("got here")
    }
    
    func didSelect(image: UIImage?, action: String, sender: UIButton) {
        
        //print("oo")
        //makes note of the change or delete
        if (action == inspectionPictures?.changeImageAction || action == inspectionPictures?.clearImageAction)
        {
            changed = true
        }
        let button = inspectionPictures!.handleChange(changedButton: sender, action: action, newImage: image)
        if (button != nil && self.editable){
            //print("Adding the new image")
            button?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
            //print("New Image added")
        }
        
    }
    
    
    
    //function for knowing when a text view changed
    func textViewDidChange(_ textView: UITextView) {
        changed = true
        //print("itWorked")
    }
    
    //if the text view has the default comment it empties the text view on edit
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == defaultComment)
        {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    //if the text view is empty it adds in the default comment
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "")
        {
            textView.text = defaultComment
            textView.textColor = UIColor.darkGray
        }
    }
}


// struct that contains the data for an inspection category
struct InspectionCategoryData
{
    var categoryName : String
    var images : [UIImage]
    var comment : String
    var applicable : String
}

//Struct that contains the category information and buttons for that category
struct InspectionCategoryStuff
{
    var categories: InspectionCategory
    var buttons: [UIButton]
}
