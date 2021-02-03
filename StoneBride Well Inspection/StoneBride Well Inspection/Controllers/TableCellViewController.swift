//
//  TableCellViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/24/20.
//  Copyright © 2020 ASU. All rights reserved.
//
import PhotosUI
import UIKit

//@available(iOS 14, *)
class TableCellViewController: UIViewController//, PHPickerViewControllerDelegate// UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var didEdit:Bool?
    var newInspectionForm:inspectionForm?
    
    var indexPath:IndexPath?
    var iFTitle: String?
    var iFDate: String?
    var iFyntext: String?
    var iFoptcomm: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ynLabel: UILabel!
    @IBOutlet weak var optLabel: UILabel!
    @IBOutlet weak var optionalComment: UILabel!
    @IBOutlet weak var YNtextfield: UILabel!
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    
    //var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = iFTitle
        titleLabel.sizeToFit()
        dateLabel.text = iFDate
        dateLabel.sizeToFit()
        
        
        YNtextfield.text = iFyntext
        YNtextfield.sizeToFit()
        optionalComment.text = iFoptcomm
        optionalComment.sizeToFit()
        // Do any additional setup after loading the view.
        
        //config.filter = .images
        //config.selectionLimit = 4
    }
    
    @IBAction func selectImage(_ sender: Any)
    {
        //let picker = PHPickerViewController(configuration: config)
        //picker.delegate = self
        //present(picker, animated: true, completion: nil)
        
        
        /*let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)*/
    }
    
    /*func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results
        {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self)
            {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let error = error
                    {
                        print(error.localizedDescription)
                    }
                    else
                    {
                        guard let wrapImage = image as? UIImage else {
                            print("Wrap Error")
                            return
                        }
                        self.imageViewer.image = wrapImage
                    }
                }
            }
            else
            {
                print("Loaded assest is not an Image")
            }
        }
    }*/
    
    
    
    
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageViewer.image = image
        
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker .dismiss(animated: true, completion: nil)
    }*/
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
