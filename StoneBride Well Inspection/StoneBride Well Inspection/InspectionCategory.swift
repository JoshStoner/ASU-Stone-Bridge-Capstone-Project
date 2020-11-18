//
//  InspectionCategory.swift
//  StoneBride Well Inspection
//
//  Created by Joshua on 11/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//
//this class is used to create all of the UI elements needed for a single inspection category on the inspection form

import UIKit

class InspectionCategory: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, ImagePickerDelegate
{
    var inspectionLabel : UILabel
    var inspectionComment : UITextField
    var inspectionPictures : ImageButtonHandler?
    var inspectionYNField : UITextField
    var defaultComment : String // the placeholder text for the comment
    var tag : Int  // the tag that all of the elements will have
    var height : Double //total height of the rectangle that the elements use
    var width : Double //total width of the rectangle that the elements use
    var hasPictures : Bool // whether or not this category has pictures
    var imagePicker : ImagePicker? //needed to present the image picker
    
    var inspectionPicturesSourceButton : UIButton?
    
    let defaultPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    
    
    let choices = ["", "Yes", "No", "N/A"] // options that can be chosen in the picker view
    
    public init(categoryName: String, topLeftPoint: CGPoint, view: UIView, tagNumber: Int, hasPictures: Bool, pullDownView: UIPickerView, imagePresenter: UIViewController)
    {
        
        self.hasPictures = hasPictures
        tag = tagNumber
        //initializes all the parts of an inspection category
        defaultComment = "add optional Comment"
        
        //initializes the inspection label
        let inspectionLabelSize = CGSize(width: 200, height: 20)
        
        inspectionLabel = UILabel(frame: CGRect(origin: topLeftPoint, size: inspectionLabelSize))
        inspectionLabel.text = categoryName
        inspectionLabel.tag = tag
        
        
        //initializes the YN text field
        let inspectionLabelYNSize = CGSize(width: 100, height: 20)
        
        inspectionYNField = UITextField(frame: CGRect(x: topLeftPoint.x + inspectionLabelSize.width + 10, y: topLeftPoint.y, width: inspectionLabelYNSize.width, height: inspectionLabelYNSize.height))
        inspectionYNField.tag = tag
        inspectionYNField.borderStyle = .bezel
        
        
        
        //initializes the comment
        let InspectionCommentFrameWidth = inspectionLabelSize.width + 10 + inspectionLabelYNSize.width
        let inspectionCommentFrame = CGRect(x: topLeftPoint.x, y: topLeftPoint.y + inspectionLabelSize.height + 10, width: InspectionCommentFrameWidth, height: 100)
        inspectionComment = UITextField(frame: inspectionCommentFrame)
        inspectionComment.placeholder = defaultComment;
        
        inspectionComment.tag = tag
        inspectionComment.borderStyle = .bezel
        
        //adds all of the UI elements to the view
        view.addSubview(inspectionLabel)
        view.addSubview(inspectionComment)
        view.addSubview(inspectionYNField)
        
        height = -1
      
        width = inspectionCommentFrame.width.native
        
        
        super.init()
        
        let pullDown = UIPickerView()
        pullDown.delegate = self
        pullDown.dataSource = self
        
        inspectionYNField.inputView = pullDown
        
        
        //initializes the picture related variables
        if (hasPictures) {
            
            imagePicker = ImagePicker(presentationController: imagePresenter, delegate: self)
            
            //creates the original picture button
            let pictureFrame = CGRect(x: topLeftPoint.x, y: inspectionCommentFrame.maxY + 10, width: InspectionCommentFrameWidth, height: 100)
            inspectionPicturesSourceButton = UIButton(frame: CGRect(x: topLeftPoint.x, y: pictureFrame.minY, width: 80, height: 60))
            inspectionPicturesSourceButton?.tag = tag
            inspectionPicturesSourceButton?.setBackgroundImage(defaultPhoto, for: .normal)
            
            inspectionPicturesSourceButton?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
            
            inspectionPictures = ImageButtonHandler(sourceButton: inspectionPicturesSourceButton!, tag: tag, numberOfButtons: 4, buttonSpace: pictureFrame)
            
            //calculates height including pictures
            height = pictureFrame.maxY.native - topLeftPoint.y.native
            
            //adds the button to the view
            view.addSubview(inspectionPicturesSourceButton!)
            
            
            
        } else {
            inspectionPictures = nil
            
            //calculates height not including pictures
            height = inspectionCommentFrame.maxY.native - topLeftPoint.y.native
        }
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
        let applicable = inspectionYNField.text
        let data = InspectionCategoryData(categoryName: category ?? "", images: images, comment: comment ?? "", applicable: applicable ?? "")
        return data
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        inspectionYNField.text = choices[row]
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
    
    func didSelect(image: UIImage?, action: String, sender: UIButton) {
        
        
        let button = inspectionPictures!.handleChange(changedButton: sender, action: action, newImage: image)
        if (button != nil){
            button?.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
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
