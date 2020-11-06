//
//  ImagePicker.swift
//  StoneBride Well Inspection
//
//  Created by Joshua on 10/17/20.
//  Copyright © 2020 ASU. All rights reserved.
// Adapted from a tutorial at theswiftdev.com/picking-images-with-uiimagepickercontroller-in-swift-5/ as well as following the UIImagePicker documentation for swift


import UIKit

//protocol for the delegate of the delegate in the ImagePicker class
// needs to be implemented in the view controller that uses the image picker
public protocol ImagePickerDelegate: class {
    // function for using the image selected
    func didSelect(image: UIImage?, action: String, sender: UIButton)
}

open class ImagePicker: NSObject {
    //the image picker controller for the class
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private let imageOverlayTag = 11111;
    //the button that initiated the presentation
    var origin: UIButton?
    
    //the names of the different actions that the image picker can do
    private let clearImageAction = "Clear"
    private let changeImageAction = "Change Image"
    
    private let testImageTitle = "Add Test Image"
    
    private let defaultImagepickerPhoto = UIImage(systemName:"plus.rectangle.on.folder")
    private let testImage = UIImage(systemName: "house")
    
    //the image preview that gets shown when a button is clicked
    private var imagePreview: UIImageView?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        //prevents editing of the image
        // I don't think it would be needed for this use case
        // if changed change the image type in the UIImagePickerControllerDelegate
        self.pickerController.allowsEditing = false
        //limits the selection to pictures
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type:UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        
        //case for if the user wants to clear the image
        if (title == clearImageAction) {
            return UIAlertAction(title: title, style: .default) { [unowned self] _ in
                self.delegate?.didSelect(image: UIImage(), action: clearImageAction, sender: origin!)
                //removes the image preview
                removeImagePreview()
                
            }
        }
        //case for adding a test image on emulator
        if (title == testImageTitle) {
            return UIAlertAction(title: title, style: .default) { [unowned self] _ in
                self.delegate?.didSelect(image: testImage, action: changeImageAction, sender: origin!)
                removeImagePreview()
                
            }
            
        }
        
        //checks if the desired source type is available
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
            
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            //removes the image preview before showing the image picker
            removeImagePreview()
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
            
        }
    }
    
    public func present(from sourceView: UIButton) {
        //makes sure the photolibrary is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        //the button that triggered this even
        origin = sourceView;
        
        addImagePreview()
        
        
        //presents the photo picker for photo library
        /*
        self.pickerController.sourceType = .photoLibrary
        self.presentationController?.present(self.pickerController, animated: false) */
        
        //presents the picker controller

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        //the first three set let the user pick or take a new photo
        // only if the presentation mode is allowed
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        //action for clearing the image
        if let action = self.action(for: .photoLibrary, title: clearImageAction){
            alertController.addAction(action)
        }
        //sets the test image as the chosen image
        if let action = self.action(for: .photoLibrary, title: testImageTitle){
            alertController.addAction(action)
        }

        //alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
            removeImagePreview()
        })

        //this shouldn't be needed
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)

    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, chosenAction action: String) {
            controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image, action: action, sender: origin!)
        }
    
    private func addImagePreview()
    {
        //adds a new image view so that the user can see the current image in a larger size
        imagePreview = UIImageView(image: origin?.backgroundImage(for: .normal))
        //I'm not sure that I handled the unwrapping properly
        //some of these ? might need to be ! or ??, I'm not totally sure
        let scrollview = origin?.superview?.superview as? UIScrollView
        imagePreview?.frame = CGRect(x: 10, y: (scrollview?.contentOffset.y ?? 0), width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 2);
        imagePreview?.tag = imageOverlayTag;
        //adds the image to the super view of the button that called this
        origin?.superview?.addSubview(imagePreview!);
        
        
    }
    
    private func removeImagePreview()
    {
            imagePreview?.removeFromSuperview();
    }
    
}

//needed to conform to the UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {
    //function that controls what happens when the user cancels out of the picker
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        
        //indicates to the picker controller that nothing was selected
        self.pickerController(picker, didSelect: nil, chosenAction: "Cancel")
    }
    
    
    //function that tells the delegate the user picked an image
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //unwraps the image then passes it to the picker controller
        guard let image = info[.editedImage] as? UIImage else {
            //lets the picker controller know that no image was picked
            self.pickerController(picker, didSelect: nil, chosenAction: "Cancel")
            return
        }
        //gives the image to the picker controller
        self.pickerController(picker, didSelect: image, chosenAction: "Change Image")
        
    }
    
}

//needed to conform to the UINavigation ControllerDelegate
//doesn't do anything currently, can add stuff later if extra navigation is needed
extension ImagePicker: UINavigationControllerDelegate {
    
}
