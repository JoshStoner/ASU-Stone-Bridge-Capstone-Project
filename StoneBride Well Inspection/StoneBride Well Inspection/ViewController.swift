//
//  ViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/10/20.
//  Copyright © 2020 ASU. All rights reserved.
//
import Network
import UIKit

class ViewController: UIViewController
{
    let networkMonitor = NWPathMonitor()
    
    
    
    var myInspectionList = inspectionList()
    
    @IBOutlet weak var size: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        // Do any additional setup after loading the view.
        
        //this is the code that gets run whenever the network status changes
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("connected")
            } else {
                print("disconnected")
            }
        }
        //starts monitoring the network connection
        let networkQueue = DispatchQueue(label: "Network Monitor")
        networkMonitor.start(queue: networkQueue)
        
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
        else if segue.identifier == "toTableView"
        {
            let des = segue.destination as! TableViewController
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
        else if let sourceViewController = segue.source as? TableViewController
        {
            let dataRecieved = sourceViewController.formList
            self.myInspectionList = dataRecieved!
            self.size.text = String(myInspectionList.getCount())
        }
    }
}

