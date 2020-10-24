//
//  TableViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/24/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var formList:inspectionList?

    @IBOutlet weak var inspectionFormTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return formList!.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        let wellName = formList!.getWellName(item: indexPath.row)
        let date = formList!.getDate(item: indexPath.row)
        
        if wellName != "",
           date != ""
        {
            cell.textLabel?.text = "\(wellName) \(date)"
        }
        else if wellName != ""
        {
            cell.textLabel?.text = "\(wellName)"
        }
        else if date != ""
        {
            cell.textLabel?.text = "\(date)"
        }
        else
        {
            cell.textLabel?.text = "\(indexPath.row)"
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            formList!.removeForm(item: indexPath.row)
        
            self.inspectionFormTable.beginUpdates()
            self.inspectionFormTable.deleteRows(at: [indexPath], with: .automatic)
            self.inspectionFormTable.endUpdates()
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func emptyTable(_ sender: Any)
    {
        //enter code to clear all data in table
        formList!.removeAllForms()
        inspectionFormTable.reloadData()
    }
    
    /*func update(iPath:IndexPath, inspecForm:inspectionForm)
    {
        self.inspectionFormTable.beginUpdates()
        //Need to update the inspection form list
        //then reload that row
        self.inspectionFormTable.endUpdates()
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toDetailView"
        {
            let selectedIndex:IndexPath = self.inspectionFormTable.indexPath(for: sender as! UITableViewCell)!
        
            let wellName = formList!.getWellName(item: selectedIndex.row)
            let date = formList!.getDate(item: selectedIndex.row)
        
        
            let des = segue.destination as! TableCellViewController
            //des.indexPath = selectedIndex
            des.iFTitle = wellName
            des.iFDate = date
        }
    }
    
    @IBAction func returnedToTable(segue: UIStoryboardSegue, sender: Any?)
    {
        //will be implemented later to allow for editing/saving from the detailview inside tableview
        /*if let sourceViewController = segue.source as? TableCellViewController
        {
            let edited = sourceViewController.didEdit
            if edited == true
            {
                let indexPath = sourceViewController.indexPath!
                let dataRecieved = sourceViewController.newInspectionForm
                update(iPath: indexPath, inspecForm: dataRecieved)
            }
        }*/
    }
    
}
