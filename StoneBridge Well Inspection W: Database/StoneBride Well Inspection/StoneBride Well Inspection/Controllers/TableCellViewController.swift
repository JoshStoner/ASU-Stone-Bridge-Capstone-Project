//
//  TableCellViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/24/20.
//  Copyright © 2020 ASU. All rights reserved.
//
import PhotosUI
import UIKit

class TableCellViewController: UIViewController
{
    var didEdit:Bool?
    
    var indexPath: IndexPath?
    var ifEnt: InspectionFormEntity?
    var iFWellName: String?
    var iFWellNumber: String?
    var iFInspecDone: String?
    var iFDate: String?
    var iFyntext: String?
    var iFoptcomm: String?

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
        
        //adds all of the inspection categories to the document
        var i = 0
        var point = CGPoint(x:10, y: 210)
        while i < 30
        {
            if i < 30
            {
                var images: [UIImage] = []
                var urls: [String] = []
                
                if (ifCategory![i].category?.pictureData?.hasPics == true)
                {
                    let savedPicEnt = (ifCategory![i].category?.pictureData?.pic?.allObjects as! [InspectionFormPicturesEntity]).sorted(by: {$0.picTag < $1.picTag})
                    
                    var j = 0
                    while j < savedPicEnt.count
                    {
                        let img = savedPicEnt[j].picData!
                        let saveImage = UIImage(data: img)
                        images.append(saveImage!)
                        urls.append(savedPicEnt[j].picURL!)
                        j += 1
                    }
                    let categoryName = inspectionCategoriesNames[i]
                    //if the form has the default comment then it replaces it with the defaultCommentReplacement when viewing the form
                    var comment = ifCategory![i].category?.optComm ?? ""
                    comment = (comment == defaultComment ? defaultCommentReplacement : comment)
                    let applicable = ifCategory![i].category?.ynAns ?? ""
                    let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                    let inspecCategoryStuff = InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: dateLabel.superview!, tagNumber: i, editable: false, hasPictures: true, numberOfPictures: images.count, loadedURLS: urls, imagePresenter: self)
                    isCategories.append(inspecCategoryStuff)
                }
                
                point.y += CGFloat(isCategories[i].projectedHeight(numberOfImages: images.count - 1, readOnly: true) + 10)
            }
            else
            {
                //This is only if there is a category that doesn't allow or want pictures.
                /*let images: [UIImage] = []
                let categoryName = inspectionCategoriesNames[i]
                let comment = ifCategory![i].category?.optComm ?? ""
                let applicable = ifCategory![i].category?.ynAns ?? ""
                let inspectionData = InspectionCategoryData(categoryName: categoryName, images:images, comment: comment, applicable: applicable)
                let inspecCategoryStuff = InspectionCategory.loadInspectionCategory(data: inspectionData, topLeftPoint: point, view: dateLabel.superview!, tagNumber: i, editable: false, hasPictures: false, numberOfPictures: 0,  imagePresenter: self)
                isCategories.append(inspecCategoryStuff)
                point.y += CGFloat(isCategories[i/* + 1*/].getHeight() + 10)*/
            }
            i += 1
        }
        increasePageLength()
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
            if newHeight > maxHeight
            {
                maxHeight = newHeight
            }
        
            uiViewHeight.constant = test + 50.0
            scrollView.subviews[0].layoutIfNeeded()
            scrollView.subviews[0].frame = CGRect(x: 0, y: 0, width: scrollView.subviews[0].frame.width, height: test + 50.0)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: test + 50.0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //prepares the inspection form view controller to load a preexisting inpsection form rather than create a new one
        if (segue.identifier == "toInspectionForm")
        {
            let des = segue.destination as! InspectionFormViewController
            des.load = true
            des.loadIndex = indexPath
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
}
