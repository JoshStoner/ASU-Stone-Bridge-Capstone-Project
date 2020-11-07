//
//  ImageButtonHandler.swift
//  StoneBride Well Inspection
//
//  Created by Joshua on 11/7/20.
//  Copyright © 2020 ASU. All rights reserved.
//  this class takes in a button as its source button, then adds new buttons to the super view of the button whenever a new picture is added

import UIKit

class ImageButtonHandler {
    private var originalButton : UIButton
    private var buttons : [UIButton]
    private var totalButtons = 1
    private var tag: Int // is the tag that all of its buttons will have
    
    //action types for the image picker, should maybe be an Enum
    //if these get changed here they need to be changed in InspectionFormViewController and ImagePicker
    let clearImageAction = "Clear"
    let changeImageAction = "Change Image"
    
    //bounding box for the buttons that will be made
    //the will be the same size as the originalButton
    private var frame: CGRect
    
    let defaultImagePickerPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    //private var buttonAction: Selector
    
    public init(sourceButton: UIButton, tag: Int)
    {
        originalButton = sourceButton
        buttons = [originalButton]
        frame = originalButton.frame
        //buttonAction = buttonFunction
        //makeButton()
        let test = UIImage(systemName: "plus.rectangle.on.folder")
        self.tag = tag
    }
    
    //helper method to create a button
    private func makeButton() -> UIButton
    {
        //for now it just takes the original buttons size and puts it just below the latest button, change this later to make better formatting decisions
        var newButtonFrame = CGRect(x: buttons[totalButtons-1].frame.origin.x, y: buttons[totalButtons-1].frame.origin.y + frame.height + 10, width: frame.width, height: frame.height)
        var newButton = UIButton(frame: newButtonFrame)
        //originalButton.actions(forTarget: <#T##Any?#>, forControlEvent: <#T##UIControl.Event#>)
        
        newButton.tag = tag
        newButton.setBackgroundImage(defaultImagePickerPhoto, for: .normal)
        originalButton.superview?.addSubview(newButton)
        buttons.append(newButton)
        totalButtons += 1
        return newButton
    }
    
    //handles what happens when a button has its image changed
    //if a new button is added it returns the new button to the class containing this to add the function to the button
    public func handleChange(changedButton: UIButton, action: String, newImage: UIImage?) -> UIButton?
    {
        var returnButton: UIButton? = nil
        
        //finds the button in the button array
        //this makes sure that this is the handler in charge of this button
        var currentButtonNumber = -1
        for button in 0..<buttons.count {
            if changedButton === buttons[button] {
                currentButtonNumber = button
            }
        }
        
        //if this button isn't a member of this handler then it exits
        if (currentButtonNumber == -1)
        {
            return nil;
        }
        
        //if the action is clear, then it needs to shift all images from this button on wards to previous buttons
        //then it should remove the last button
        if (action == clearImageAction && changedButton.backgroundImage(for: .normal) !== defaultImagePickerPhoto)
        {
            
            
            //shifts the images back
            for button in currentButtonNumber..<(buttons.count-1){
                buttons[button].setBackgroundImage(buttons[button+1].backgroundImage(for: .normal), for: .normal)
            }
            
            //removes the last button from the view, then deletes it
            //if there are more than one buttons
            if (totalButtons > 1)
            {
                totalButtons -= 1
                buttons.popLast()?.removeFromSuperview()
            }
        
        } else if (action == changeImageAction)
        {
            //only makes a new button if this is the first image set to this button
            if (changedButton.backgroundImage(for: .normal) === defaultImagePickerPhoto)
            {
                //makes a new button and adds it to the super view
                returnButton = makeButton()
                
            }
            changedButton.setBackgroundImage(newImage, for: .normal)
            
        }
        return returnButton
    }
    
}
