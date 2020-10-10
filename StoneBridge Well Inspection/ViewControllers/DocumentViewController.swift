//
//  DocumentViewController.swift
//  StoneBridge Well Inspection
//
//  Created by Joshua on 10/9/20.
//  This is the view controller that will display the inspection document


import UIKit

class DocumentViewController: UIViewController {
    // an array of all the different inspection descriptions
    let InspectionCategories = ["Pictures of the Well", "Pictures of the Tank Battery", "Pictures of the Location", "Pictures of the Lease Road", "Any Spills to clear up", "Any gas leaks, oil leaks on fittings", "Any leaks around wellhead", "Does any brush need cut", "Does  it need weedeated", "Any trash that needs picked up", "Any erosion occurring", "Are there concrete vaults", "Are there old salt water pits", "Does new ID placement need painted", "Tank Gauges", "Oil BBLS:     WaterBBLS:", "Any electtric drops", "Electric Meter Number", "Pump Jack make & Size", "Tubing Size", "# of Tanks and Size", "Plastic Tank/Size", "Oriifce Meter", "Separator", "Electric Motor & Size", "Gasoline Engine and Size", "Electric Line Overhead # of poles", "Concrete Sills", "Fence", "House Gas Meter/with Little Joe/Drip"]
    //This function creates a view for each well inspection category
    func createInspectionView(category: String, y: Int) -> UIView {
        //the view that holds everything
        var inspectionView = UIView(frame: CGRect(x: 0, y: y, width: Int(view.bounds.width), height: 100))
        
        inspectionView.backgroundColor = UIColor.blue
        
        //a label to describe which category this InspectionView is for
        var inspectionCategory = UILabel(frame: CGRect(x: 10, y: 0, width: Int(view.bounds.width) - 20, height: 20))
        
        inspectionCategory.text = category;
        inspectionCategory.adjustsFontSizeToFitWidth = true
        
        //a text field for the employee to add their comments
        var inspectionComment = UITextField(frame: CGRect(x: 10, y: 25, width: Int(view.bounds.width) - 20, height: 20))
        
        //sets the placeholder text for the comment
        inspectionComment.placeholder = "Enter an optional Comment"
        inspectionComment.backgroundColor = UIColor.gray
        //needs to have something in place to make the keyboard go away when
        //the inspection Comment is clicked off of
        
        //a switch for the employee to easily select yes or no
        var yesNoSwitch = UISwitch(frame: CGRect(x: 70, y: 50, width: Int(view.bounds.width) - 20, height: 20))
        //label to indicate that the switch is for Yes No
        var yesNoLabel = UILabel(frame: CGRect(x: 10, y: 50, width: Int(view.bounds.width) - 20, height: 20))
        yesNoLabel.text = "Yes/No"
        
        //UI components for the employee to indicate if the inspection category applies to this well
        var applicableSwitch = UISwitch(frame: CGRect(x: 100, y: 75, width: Int(view.bounds.width) - 20, height: 20))
        var applicableLabel = UILabel(frame: CGRect(x: 10, y: 75, width: Int(view.bounds.width) - 20, height: 20))
        applicableLabel.text = "Applicable?"
        
        //adds all of the UI elements to the view
        inspectionView.addSubview(inspectionCategory)
        inspectionView.addSubview(inspectionComment)
        inspectionView.addSubview(yesNoLabel)
        inspectionView.addSubview(yesNoSwitch)
        inspectionView.addSubview(applicableLabel)
        inspectionView.addSubview(applicableSwitch)
        
        return inspectionView
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 0..<InspectionCategories.count {
            var newView = createInspectionView(category: InspectionCategories[i], y: i * 110)
            view.addSubview(newView)
            
        }
    }


}
