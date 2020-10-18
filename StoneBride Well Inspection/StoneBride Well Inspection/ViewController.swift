//
//  ViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    var myInspectionList = inspectionList()
    
    @IBOutlet weak var size: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        // Do any additional setup after loading the view.
    }
    
    func update()
    {
        self.size.text = String(myInspectionList.getCount())
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toInspectionForm"
        {
            let des = segue.destination as! InspectionFormViewController
            des.formList = myInspectionList
        }
    }
    
    @IBAction func returnedToMenu(segue: UIStoryboardSegue, sender: Any?)
    {
        if let sourceViewController = segue.source as? InspectionFormViewController
        {
            let dataRecieved = sourceViewController.formList
            self.myInspectionList = dataRecieved!
            self.size.text = String(myInspectionList.getCount())
        }
    }
}

