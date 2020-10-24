//
//  TableCellViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/24/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class TableCellViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var didEdit:Bool?
    var newInspectionForm:inspectionForm?
    
    var indexPath:IndexPath?
    var iFTitle: String?
    var iFDate:String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = iFTitle
        titleLabel.sizeToFit()
        dateLabel.text = iFDate
        dateLabel.sizeToFit()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImage(_ sender: Any)
    {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageViewer.image = image
        
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker .dismiss(animated: true, completion: nil)
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
