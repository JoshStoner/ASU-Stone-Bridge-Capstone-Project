//
//  ImagePicker.swift
//  StoneBride Well Inspection
//
//  Created by Joshua on 10/17/20.
//  Copyright © 2020 ASU. All rights reserved.
// Adapted from a tutorial at theswiftdev.com/picking-images-with-uiimagepickercontroller-in-swift-5/ as well as following the UIImagePicker documentation for swift
//currently the goal is to get taking photos working

import UIKit

//protocol for the delegate of the delegate in the ImagePicker class
// needs to be implemented in the view controller that uses the image picker
public protocol ImagePickerDelegate: class {
    // function for using the image selected
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    //the image picker controller for the class
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
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
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
            guard UIImagePickerController.isSourceTypeAvailable(type) else {
                return nil
            }

            return UIAlertAction(title: title, style: .default) { [unowned self] _ in
                self.pickerController.sourceType = type
                self.presentationController?.present(self.pickerController, animated: true)
            }
        }
        
        public func present(from sourceView: UIView) {
            //makes sure the photolibrary is available
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                return
            }
            
            //presents the photo picker for photo library
            self.pickerController.sourceType = .photoLibrary
            self.presentationController?.present(self.pickerController, animated: false)
            
            //presents the picker controller
/*      this part is copy pasted from the tutorial
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            if let action = self.action(for: .camera, title: "Take photo") {
                alertController.addAction(action)
            }
            if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
                alertController.addAction(action)
            }
            if let action = self.action(for: .photoLibrary, title: "Photo library") {
                alertController.addAction(action)
            }

            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            }

            self.presentationController?.present(alertController, animated: true)
 */
        }

        private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
            controller.dismiss(animated: true, completion: nil)

            self.delegate?.didSelect(image: image)
        }
    
}

//needed to conform to the UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {
    //function that controls what happens when the user cancels out of the picker
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //indicates to the picker controller that nothing was selected
        self.pickerController(picker, didSelect: nil)
    }
    
    
    //function that tells the delegate the user picked an image
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //unwraps the image then passes it to the picker controller
        guard let image = info[.editedImage] as? UIImage else {
            //lets the picker controller know that no image was picked
            self.pickerController(picker, didSelect: nil)
            return
        }
        //gives the image to the picker controller
        self.pickerController(picker, didSelect: image)
        
    }
    
}

//needed to conform to the UINavigation ControllerDelegate
//doesn't do anything currently, can add stuff later if extra navigation is needed
extension ImagePicker: UINavigationControllerDelegate {
    
}
