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
    var DB = Database()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DB.DatabaseConnection()
        DB.delete()
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
   
    @IBAction func returnedToMenu(segue: UIStoryboardSegue, sender: Any?)
    {
    }
}

