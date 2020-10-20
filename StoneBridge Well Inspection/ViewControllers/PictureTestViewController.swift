//
//  PictureTestViewController.swift
//  StoneBridge Well Inspection
//
//  Created by Joshua on 10/18/20.
// This class is just to test 

import UIKit

class PictureTestViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    @IBAction func showImagePicker(_ sender: UIButton){
        self.imagePicker.present(from: sender)
    }
    
}

extension PictureTestViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}
