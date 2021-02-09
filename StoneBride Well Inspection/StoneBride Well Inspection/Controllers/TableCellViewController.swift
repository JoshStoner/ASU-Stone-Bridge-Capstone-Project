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

    var fetchResults = [InspectionFormEntity]()
    
    var ifCategory : [InspectionFormCategoryEntity]?
    
    
    //holds all of the inspection categories
    private var isCategories : [InspectionCategory] = []
    
    // an array of all the different inspection descriptions
        let inspectionCategoriesNames = ["Pictures of the Well", "Pictures of the Tank Battery", "Pictures of the Location", "Pictures of the Lease Road", "Any Spills to clean up", "Any gas leaks, oil leaks on fittings", "Any leaks around wellhead", "Does any brush need cut", "Does  it need weedeated", "Any trash that needs picked up", "Any erosion occurring", "Are there concrete vaults", "Are there old salt water pits", "Does new ID placement need painted", "Tank Gauges", "Oil BBLS:     WaterBBLS:", "Any electric drops", "Electric Meter Number", "Pump Jack make & Size", "Tubing Size", "# of Tanks and Size", "Plastic Tank/Size", "Oriifce Meter", "Separator", "Electric Motor & Size", "Gasoline Engine and Size", "Electric Line Overhead # of poles", "Concrete Sills", "Fence", "House Gas Meter/with Little Joe/Drip"]
    
    
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
        
        //fectches data from core data
        //var testing = fetchResults[indexPath!.row].section
        //NSSortDescriptor sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tagN" ascending:YES]
        //var ee = (testing?.allObjects as! [InspectionFormCategoryEntity]).sorted(by: {$0.tagN < $1.tagN})
        
        //adds all of the inspection categories to the document
        var i = 0
        var point = CGPoint(x:10, y: 210)
        while i < 30
        {
        
            if i < 4
            {
                var images: [UIImage] = []
                
                if (ifCategory![i].category?.pictureData?.hasPics == true)
                {
                    let savedPicEnt = (ifCategory![i].category?.pictureData?.pic?.allObjects as! [InspectionFormPicturesEntity]).sorted(by: {$0.picTag < $1.picTag})
                    
                    //print("Before")
                    //print(savedPicEnt.count)
                    //print(savedPicEnt[i].picTag)
                    //print("AFTER")
                    
                    var j = i
                    //print("In loop")
                    while j < savedPicEnt.count
                    {
                        //print(savedPicEnt[j].picData)
                        let img = savedPicEnt[j].picData!
                        let saveImage = UIImage(data: img)
                        images.insert(saveImage!, at: j)
                        //images.append(saveImage!)
                        //print("images.count = \(images.count)")
                        //print("Added an img to images")
                        //print("j = \(j)")
                        //print("images.count = \(images.count)")
                        //print("images = \(images)")
                        j += 1
                    }
                    //print("Out of loop")
                    //print("images.count = \(images.count)")
                    //print("images = \(images)")
                    let categoryName = inspectionCategoriesNames[i]
                    let comment = ifCategory![i].category?.optComm ?? ""
                    let applicable = ifCategory![i].category?.ynAns ?? ""
                    let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                    isCategories.append(InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: YNtextfield.superview!, tagNumber: i, editable: false, hasPictures: true, numberOfPictures: images.count,  imagePresenter: self))
                }
                //print(i)
                point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                
            }
            else
            {
                let images: [UIImage] = []
                let categoryName = inspectionCategoriesNames[i]
                let comment = ifCategory![i].category?.optComm ?? ""
                let applicable = ifCategory![i].category?.ynAns ?? ""
                let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                isCategories.append(InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: YNtextfield.superview!, tagNumber: i, editable: false, hasPictures: false, numberOfPictures: 0,  imagePresenter: self))
                point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
            }
            i += 1
        }
            
        print(point.y)
        
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
