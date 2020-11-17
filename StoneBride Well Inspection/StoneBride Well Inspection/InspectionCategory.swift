//
//  InspectionCategory.swift
//  StoneBride Well Inspection
//
//  Created by Joshua on 11/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//
//this class is used to create all of the UI elements needed for a single inspection category on the inspection form

import UIKit

class InspectionCategory {
    var inspectionLabel : UILabel
    var inspectionComment : UITextField
    var inspectionPictures : ImageButtonHandler?
    var inspectionYNField : UITextField
    var defaultComment : String // the placeholder text for the comment
    var tag : Int  // the tag that all of the elements will have
    var height : Double //total height of the rectangle that the elements use
    var width : Double //total width of the rectangle that the elements use
    var hasPictures : Bool // whether or not this category has pictures
    
    
    var inspectionPicturesSourceButton : UIButton?
    
    let defaultPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    public init(categoryName: String, topLeftPoint: CGPoint, view: UIView, tagNumber: Int, hasPictures: Bool, pullDownView: UIPickerView)
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
        inspectionYNField.inputView = pullDownView
        
        
        //initializes the comment
        let InspectionCommentFrameWidth = inspectionLabelSize.width + 10 + inspectionLabelYNSize.width
        let inspectionCommentFrame = CGRect(x: topLeftPoint.x, y: topLeftPoint.y + inspectionLabelSize.height + 10, width: InspectionCommentFrameWidth, height: 100)
        inspectionComment = UITextField(frame: inspectionCommentFrame)
        inspectionComment.placeholder = defaultComment;
        
        inspectionComment.tag = tag
        
        //adds all of the UI elements to the view
        view.addSubview(inspectionLabel)
        view.addSubview(inspectionComment)
        view.addSubview(inspectionYNField)
        
        
        //initializes the picture related variables
        if (hasPictures) {
            let pictureFrame = CGRect(x: topLeftPoint.x, y: inspectionCommentFrame.maxY + 10, width: InspectionCommentFrameWidth, height: 100)
            inspectionPicturesSourceButton = UIButton(frame: CGRect(x: topLeftPoint.x, y: pictureFrame.minY, width: 80, height: 60))
            inspectionPicturesSourceButton?.tag = tag
            inspectionPicturesSourceButton?.setBackgroundImage(defaultPhoto, for: .normal)
            
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
        width = inspectionCommentFrame.width.native
        
        
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
    
}


// struct that contains the data for an inspection category
struct InspectionCategoryData
{
    var categoryName : String
    var images : [UIImage]
    var comment : String
    var applicable : String
}
