//
//  TableViewController.swift
//  StoneBride Well Inspection
//
//  Created by Tyler on 10/24/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var iModel:inspectionFormModel?
    var fetchResults = [InspectionFormEntity]()
    var selectedInspecEntity:InspectionFormEntity?
    
    @IBOutlet weak var inspectionFormTable: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        iModel = inspectionFormModel(context: managedObjectContext)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let fetchRequest:NSFetchRequest<InspectionFormEntity> = InspectionFormEntity.fetchRequest()
        
        do
        {
            fetchResults = try managedObjectContext.fetch(fetchRequest)
            inspectionFormTable.reloadData()
        }
        catch
        {
            print("Failed to fetch inspection forms")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (iModel?.fetchCount())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        fetchResults = (iModel?.updateList())!
        
        var wellName = ""
        var date = ""
        
        wellName = fetchResults[indexPath.row].wellName!
        date = fetchResults[indexPath.row].date!
        
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            //alerts the user they are about to delete an inspection form
            //could add some logic to indicate if the form has been sent to the database
            let alert = UIAlertController(title: "Delete Form", message: "Are you sure you want to delete this inspection form? This action cannot be undone.", preferredStyle: .alert)
            
            //the cancel action
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            //the delete action
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(_) -> () in
                let inspecEnt = self.fetchResults[indexPath.row]
                let managedContext = inspecEnt.managedObjectContext
                managedContext?.delete(inspecEnt)
                do
                {
                    try managedContext?.save()
                    self.fetchResults.remove(at: indexPath.row)
                    self.inspectionFormTable.deleteRows(at: [indexPath], with: .automatic)
                }
                catch
                {
                    print("Couldn't delete the inspection form")
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func emptyTable(_ sender: Any)
    {
        //alerts the user they are about to delete an inspection form
        //could add some logic to indicate if the form has been sent to the database
        let alert = UIAlertController(title: "Delete All Forms", message: "Are you sure you want to delete all inspection forms listed in the table? This action cannot be undone.", preferredStyle: .alert)
        
        //the cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        //the delete action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(_) -> () in
            self.iModel?.clearData()
            self.fetchResults.removeAll()
            self.inspectionFormTable.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toDetailView"
        {
            let selectedIndex:IndexPath = self.inspectionFormTable.indexPath(for: sender as! UITableViewCell)!
        
            var wellName = ""
            var wellNumber = ""
            var inspectionDoneBy = ""
            var date = ""
            var yn = "1"
            var opt = "1"
            
            var i = 0
            
            let ent = fetchResults[selectedIndex.row]
            
            let testing = fetchResults[selectedIndex.row].section
            //NSSortDescriptor sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tagN" ascending:YES]
            let ee = (testing?.allObjects as! [InspectionFormCategoryEntity]).sorted(by: {$0.tagN < $1.tagN})
            
            wellName = fetchResults[selectedIndex.row].wellName!
            wellNumber = "\(fetchResults[selectedIndex.row].wellNumber)"
            inspectionDoneBy = fetchResults[selectedIndex.row].inspectionDone!
            date = fetchResults[selectedIndex.row].date!
            while i < ee.count
            {
                if (i > 30)
                {
                    break
                }
                if Int(ee[i].tagN) == 6
                {
                    yn = (ee[i].category?.ynAns)!
                    opt = (ee[i].category?.optComm)!
                    break
                }
                i += 1
            }
                
            let des = segue.destination as! TableCellViewController
            des.iFWellName = wellName
            des.iFWellNumber = wellNumber
            des.iFInspecDone = inspectionDoneBy
            des.iFDate = date
            des.iFyntext = yn
            des.iFoptcomm = opt
            des.indexPath = selectedIndex
            des.ifCategory = ee
            des.ifEnt = ent
        }
    }
    
    @IBAction func returnedToTable(segue: UIStoryboardSegue, sender: Any?)
    {
    }
    
}

