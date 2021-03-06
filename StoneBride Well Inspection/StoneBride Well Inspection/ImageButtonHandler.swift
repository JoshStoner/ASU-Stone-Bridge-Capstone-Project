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
    var buttons : [UIButton]
    private var totalButtons = 1
    private var tag: Int // is the tag that all of its buttons will have
    private var maxButtons: Int // total number of buttons that this can handle
    private var buttonSpace: CGRect // the space in the application that the buttons can be spawned in
    private var totalPictures = 0 // stores the number of buttons that have an actual image in them
    
    //the amount of space that will be added between buttons
    private var xGap = 10
    private var yGap = 10
    
    //stores the legal x y coordinates that buttons can have
    private var buttonPositions : [CGPoint]
    
    //action types for the image picker, should maybe be an Enum
    //if these get changed here they need to be changed in InspectionFormViewController and ImagePicker
    let clearImageAction = "Clear"
    let changeImageAction = "Change Image"
    
    //bounding box for the buttons that will be made
    //the will be the same size as the originalButton
    private var frame: CGRect
    
    let defaultImagePickerPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    //private var buttonAction: Selector
    
    //button space currently assumes that it has unlimited height to work with and new buttons will have space made for them
    public init(sourceButton: UIButton, tag: Int, numberOfButtons: Int, buttonSpace: CGRect)
    {
        originalButton = sourceButton
        buttons = [originalButton]
        frame = originalButton.frame
        maxButtons = numberOfButtons
        self.buttonSpace = CGRect(x: buttonSpace.minX, y: buttonSpace.minY, width: buttonSpace.width, height: CGFloat((Int(frame.height) + yGap) * numberOfButtons))
        
        
        //buttonAction = buttonFunction
        //makeButton()
        self.tag = tag
        
        buttonPositions = [sourceButton.frame.origin]
        
        //finds possible button coordinate
        findCoordinates()
    }
    
    //helper method to create a button
    private func makeButton(newTag: Int) -> UIButton
    {
        var newButtonFrame:CGRect
        print("buttonPositions[count] = \(buttonPositions[totalButtons-1])")
        if buttonPositions[totalButtons-1].x != 190.0
        {
            print("!=")
            newButtonFrame = CGRect(x: buttonPositions[totalButtons].x, y: buttonPositions[totalButtons-1].y, width: frame.width, height: frame.height)
        }
        else
        {
            print("=")
            newButtonFrame = CGRect(x: buttonPositions[totalButtons].x, y: buttonPositions[totalButtons-1].y+70.0, width: frame.width, height: frame.height)
        }
        // uses the next button position for setting the coordinates
        
        print("newButtonFrame = \(newButtonFrame)")
        let newButton = UIButton(frame: newButtonFrame)
        //originalButton.actions(forTarget: <#T##Any?#>, forControlEvent: <#T##UIControl.Event#>)
        
        newButton.tag = newTag
        newButton.setBackgroundImage(defaultImagePickerPhoto, for: .normal)
        //print(originalButton.superview?.superview)
        //print(originalButton.superview)
        originalButton.superview?.addSubview(newButton)
        buttons.append(newButton)
        buttonPositions[totalButtons] = newButtonFrame.origin
        totalButtons += 1
        //findCoordinates()
        
        return newButton
    }
    
    //with an update to how the inspection category works, this might not need to return the button any more
    //handles what happens when a button has its image changed
    //if a new button is added it returns the new button to the class containing this to add the function to the button
    public func handleChange(changedButton: UIButton, action: String, newImage: UIImage?) -> UIButton?
    {
        var returnButton: UIButton? = nil
        
        //finds the button in the button array
        //this makes sure that this is the handler in charge of this button
        var currentButtonNumber = -1
        for button in 0..<buttons.count {
            if changedButton == buttons[button]//had 3 equal signs
            {
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
            //if there are more than one buttons and not at the max number of buttons with each button haveing a picture
            if (totalButtons > 1 && totalPictures != maxButtons)
            {
                totalButtons -= 1
                buttons.popLast()?.removeFromSuperview()
                
                //if we're at max buttons and each has a picture then it just sets the last buttons picture to the default image
            } else if (totalPictures == maxButtons)
            {
                buttons[totalButtons-1].setBackgroundImage(defaultImagePickerPhoto, for: .normal)
            }
            //updates the image count
            totalPictures -= 1
        
        } else if (action == changeImageAction)
        {
            //only makes a new button if this is the first image set to this button, and the max number of buttons hasn't been reached
            if (changedButton.backgroundImage(for: .normal) == defaultImagePickerPhoto)
            {
                totalPictures += 1
                if (totalButtons < maxButtons)
                {
                    //makes a new button and adds it to the super view
                    returnButton = makeButton(newTag: changedButton.tag+1)
                }
                
            }
            //changedButton.setImage(newImage, for: .normal)
            changedButton.setBackgroundImage(newImage, for: .normal)
            
        }
        return returnButton
    }
    
    //used to programmatically add an image
    //returns buttons that need to have actions added to them
    public func addImage(image: UIImage) -> UIButton?
    {
        
        //makes sure there is a button to put the image in
        if (totalPictures < maxButtons)
        {
            return handleChange(changedButton: buttons[totalButtons-1], action: changeImageAction, newImage: image)
            
        }
        return nil
    }
    
    //returns the max y position taken up by a button
    public func getHeight() -> CGFloat
    {
        return buttons[totalButtons-1].frame.maxY
    }
    
    // this can be used before images have been added to get the estimated height of the buttons
    // returns the expected max y coordinate taken up by a button
    // this does take into consideration the button used to add another image
    public func getProjectedHeight(numberOfImages: Int) -> CGFloat
    {
        if (numberOfImages < 0 || numberOfImages > maxButtons)
        {
            return frame.minX
        }
        //adds the height of the frame to its y coordinate
        return buttonPositions[numberOfImages].y + frame.height
    }
    
    //finds legal coordinates for buttons inside of the given space for the imagebuttonhandler
    //it finds up to maxButton coordinates. if it terminates early then it sets max buttons to the number of coordinates that it found
    // lays out buttons in a grid starting from the position of the given button
    //prefers moving right before moving down
    //assumes that the coordinates of the first button are legal
    private func findCoordinates()
    {
        var canMoveRight = true
        var canMoveDown = true
        var rightAmount = 1
        var downAmount = 0
        let origin = frame.origin // the location of the original button
        print("frame origin = \(frame.origin)")
        while(canMoveDown && buttonPositions.count < maxButtons)
        {
            while(canMoveRight)
            {
                
                //determines what the frame for a button at this point would look like
                // its broken up to make it easier to read and so the compiler can type check easier
                
                let newX = origin.x + (frame.width + CGFloat(xGap)) * CGFloat(rightAmount)
                let newY =  origin.y + (frame.height + CGFloat(yGap)) * CGFloat(downAmount)
                let newOrigin = CGPoint(x: newX,y: newY)
                print("new Origin = \(newOrigin)")
                //let newFrame = CGRect(x: newX, y: newY, width: CGFloat(frame.width), height: CGFloat(frame.height))
                let newFrame = CGRect(origin: newOrigin, size: frame.size)
                


                let legal = buttonSpace.contains(newFrame)

                //if it is a legal space for the button it adds the origin to the button positions
                if (legal)
                {
                    buttonPositions.append(newFrame.origin)
                    //stops if it found enough legal positions
                    if (buttonPositions.count == maxButtons)
                    {
                        //signals to exit the loop
                        canMoveRight = false
                        canMoveDown = false
                    }
                    
                    
                } else
                {
                    //if not legal it determines if that was the last possible legal position
                    if (rightAmount == 0)
                    {
                        canMoveDown = false
                    }
                    canMoveRight = false
                }
                
                //moves the point to the right
                rightAmount += 1
            }
            //resets the rightAmount and sets can move right to true
            rightAmount = 0
            canMoveRight = true
            //moves to the next row of positions
            downAmount += 1
            
        }
        
        //checks to see if it found enough positions for the total possible number of buttons, if it didn't it sets the max buttons to the number of buttons that fit in the given space
        if (buttonPositions.count < maxButtons)
        {
            maxButtons = buttonPositions.count
        }
        
    }
    
    //creates an array that holds all of the images that have been added to buttons in this handler
    public func getImages() -> [UIImage]
    {
        var images: [UIImage] = []
        var i = 0
        var moreImages = true
        while(i < buttons.count && moreImages)//buttons.count used to be maxButtons
        {
            let buttonImage = buttons[i].backgroundImage(for: .normal)
            //if the image is the default image there are no more images
            if (buttonImage == defaultImagePickerPhoto || buttonImage == nil)
            {
                moreImages = false
            } else
            {
                images.append(buttonImage!)
            }
            
            i += 1
        }
        
        return images
    }
    
    //moves all the buttons down by amount
    public func shiftButtonsVertically(amount: Int)
    {
        var count = 0
        for button in buttons
        {
            
            //print("Button frame before \(button.frame)")
            //print("Before buttons[count].frame = \(buttons[count].frame)")
            //print("Before buttonPositions[count] = \(buttonPositions[count])")
            button.frame = CGRect(x: button.frame.minX, y: button.frame.minY + CGFloat(amount), width: button.frame.width, height: button.frame.height)
            buttons[count] = button
            buttonPositions[count] = button.frame.origin
            //print("Button frame before \(button.frame)")
            //print("After buttons[count].frame = \(buttons[count].frame)")
            //print("After buttonPositions[count] = \(buttonPositions[count])")
            count += 1
        }
    }
    
    //Used to get all of the buttons to show in the InspectionFormViewController starting at line 221
    public func getButtons() -> [UIButton]
    {
        return buttons
    }
    
    public func getMaxButtons() -> Int
    {
        return maxButtons
    }
    
}
