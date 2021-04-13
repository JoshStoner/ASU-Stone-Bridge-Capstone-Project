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
    
    var indexPath: IndexPath?
    var ifEnt: InspectionFormEntity?
    var iFWellName: String?
    var iFWellNumber: String?
    var iFInspecDone: String?
    var iFDate: String?
    var iFyntext: String?
    var iFoptcomm: String?

    //var formList: inspectionList?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiViewHeight: NSLayoutConstraint!
    
    var fetchResults = [InspectionFormEntity]()
    
    var ifCategory : [InspectionFormCategoryEntity]?
    
    let defaultComment = "Add optional comment"
    let defaultCommentReplacement = "No Comment"
    
    //holds all of the inspection categories
    private var isCategories : [InspectionCategory] = []
    
    let inspectionCategoriesNames = ["Pictures of the Lease Road", "Pictures of the Tank Battery", "Are there concrete vaults", "Are there old salt water pits", "Does it need new ID/repaint", "Tank Gauges", "Oil BBLS:     Water BBLS:", "# of Tanks and Size", "Plastic Tank/Size", "Orifice Meter", "Separator", "House Gas Meter/with Little Joe/Drip", "Pictures of the Well", "Pump Jack Make & Size", "Tubing Size", "Electric Motor & Size", "Gasoline Engine & Size", "Concrete Sills", "Any leaks around Wellhead", "Pictures of the Well Location", "Any spills to clean up", "Any gas leaks, oil leaks on fittings", "Does any brush need cut", "Does it need weedeated", "Any trash that needs picked up", "Any erosion occuring", "Any electric drops", "Electric Meter Number", "Electric Line overhead # of poles", "Fence"]
    
    // an array of all the different inspection descriptions
      //  let inspectionCategoriesNames = ["Pictures of the Well", "Pictures of the Tank Battery", "Pictures of the Location", "Pictures of the Lease Road", "Any Spills to clean up", "Any gas leaks, oil leaks on fittings", "Any leaks around wellhead", "Does any brush need cut", "Does  it need weedeated", "Any trash that needs picked up", "Any erosion occurring", "Are there concrete vaults", "Are there old salt water pits", "Does new ID placement need painted", "Tank Gauges", "Oil BBLS:     WaterBBLS:", "Any electric drops", "Electric Meter Number", "Pump Jack make & Size", "Tubing Size", "# of Tanks and Size", "Plastic Tank/Size", "Oriifce Meter", "Separator", "Electric Motor & Size", "Gasoline Engine and Size", "Electric Line Overhead # of poles", "Concrete Sills", "Fence", "House Gas Meter/with Little Joe/Drip"]

    
    @IBOutlet weak var wellNameLabel: UILabel!
    @IBOutlet weak var wellNumberLabel: UILabel!
    @IBOutlet weak var inspectionDoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        wellNameLabel.text = iFWellName
        wellNameLabel.sizeToFit()
        wellNumberLabel.text = iFWellNumber
        wellNumberLabel.sizeToFit()
        inspectionDoneLabel.text = iFInspecDone
        inspectionDoneLabel.sizeToFit()
        dateLabel.text = iFDate
        dateLabel.sizeToFit()
        //print("ok")
        //print(dateLabel.superview!)
        //YNtextfield.text = iFyntext
        //YNtextfield.sizeToFit()
        //optionalComment.text = iFoptcomm
        //optionalComment.sizeToFit()
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
            if i < 30//4
            {
                var images: [UIImage] = []
                
                if (ifCategory![i].category?.pictureData?.hasPics == true)
                {
                    let savedPicEnt = (ifCategory![i].category?.pictureData?.pic?.allObjects as! [InspectionFormPicturesEntity]).sorted(by: {$0.picTag < $1.picTag})
                    
                    //print("Before")
                    //print(savedPicEnt.count)
                    //print(savedPicEnt[i].picTag)
                    //print("AFTER")
                    
                    var j = 0 //changed from i to 0
                    //print("In loop")
                    while j < savedPicEnt.count
                    {
                        //print(savedPicEnt[j].picData)
                        let img = savedPicEnt[j].picData!
                        let saveImage = UIImage(data: img)
                        //images.insert(saveImage!, at: j) // this didn't work for me when there was more than one image saved but below did - Josh
                        images.append(saveImage!)
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
                    //if the form has the default comment then it replaces it with the defaultCommentReplacement when viewing the form
                    var comment = ifCategory![i].category?.optComm ?? ""
                    comment = (comment == defaultComment ? defaultCommentReplacement : comment)
                    let applicable = ifCategory![i].category?.ynAns ?? ""
                    let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                    let inspecCategoryStuff = InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: dateLabel.superview!, tagNumber: i, editable: false, hasPictures: true, numberOfPictures: images.count,  imagePresenter: self)
                    isCategories.append(inspecCategoryStuff)
                }
                //print(i)
                //point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
                
                point.y += CGFloat(isCategories[i].projectedHeight(numberOfImages: images.count - 1, readOnly: true) + 10)
            }
            else
            {
                let images: [UIImage] = []
                let categoryName = inspectionCategoriesNames[i]
                let comment = ifCategory![i].category?.optComm ?? ""
                let applicable = ifCategory![i].category?.ynAns ?? ""
                let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                let inspecCategoryStuff = InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: dateLabel.superview!, tagNumber: i, editable: false, hasPictures: false, numberOfPictures: 0,  imagePresenter: self)
                isCategories.append(inspecCategoryStuff)
                point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)
            }
            i += 1
        }
        increasePageLength()
        //print(point.y)
        
    }
    
    func increasePageLength()
    {
        
        var maxHeight : CGFloat = 0
        var test : CGFloat = 0
        for view in self.scrollView.subviews
        {
            for subView in view.subviews
            {
                let t = subView.frame.origin.y + subView.frame.height
                if t > test
                {
                    test = t
                }
            }
            let newHeight = view.frame.origin.y + view.frame.height
            //print(subView.frame.origin.y)
            if newHeight > maxHeight
            {
                maxHeight = newHeight
            }
        
        //print(maxHeight)
        //print(test)
        //print(scrollView.contentSize.height)
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 12000.0)
            uiViewHeight.constant = test + 50.0
            scrollView.subviews[0].layoutIfNeeded()
            scrollView.subviews[0].frame = CGRect(x: 0, y: 0, width: scrollView.subviews[0].frame.width, height: test + 50.0)
            
            //scrollView.subviews[0].sizeToFit()
            //scrollView.subviews[0].frame.height = test + 50.0
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: test + 50.0)
        }
        //print(scrollView.contentSize.height)
        //print(scrollView.subviews[0].frame.height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //prepares the inspection form view controller to load a preexisting inpsection form rather than create a new one
        if (segue.identifier == "toInspectionForm")
        {
            let des = segue.destination as! InspectionFormViewController
            des.load = true
            des.loadIndex = indexPath
            //des.formList = formList
            des.loadedCategories = ifCategory
            des.loadedEnt = ifEnt!
            des.loadedWellName = iFWellName
            des.loadedWellNumber = iFWellNumber
            des.loadedInspecDone = iFInspecDone
            des.loadedDate = iFDate
            deleteStuff()
            dismiss(animated: true, completion: nil)
        }
        else if(segue.identifier == "CellToTable")
        {
            deleteStuff()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteStuff()
    {
        didEdit = nil
        newInspectionForm = nil
        
        indexPath = nil
        ifEnt = nil
        iFWellName = nil
        iFWellNumber = nil
        iFInspecDone = nil
        iFDate = nil
        iFyntext = nil
        iFoptcomm = nil
        
        ifCategory = nil
        
        isCategories = []
        print("Stuff deleted from TableCellViewController")
    }
    
    //@IBAction func selectImage(_ sender: Any)
    //{
        //let picker = PHPickerViewController(configuration: config)
        //picker.delegate = self
        //present(picker, animated: true, completion: nil)
        
        
        /*let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)*/
    //}
    
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
