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
    //let managedObjectContext: NSManagedObjectContext?
    
    var formList:inspectionList?
    
    var iModel:inspectionFormModel?
    var fetchResults = [InspectionFormEntity]()
    var selectedInspecEntity:InspectionFormEntity?
    
    
    
    @IBOutlet weak var inspectionFormTable: UITableView!
    
    /*init(context: NSManagedObjectContext)
    {
        managedObjectContext = context
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
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
        //return formList!.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        fetchResults = (iModel?.updateList())!
        
        var wellName = ""
        var date = ""
        
        wellName = fetchResults[indexPath.row].wellName!
        date = fetchResults[indexPath.row].date!
        
        //let wellName = formList!.getWellName(item: indexPath.row)
        //let date = formList!.getDate(item: indexPath.row)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let inspecEnt = fetchResults[indexPath.row]
            let managedContext = inspecEnt.managedObjectContext
            managedContext?.delete(inspecEnt)
            do
            {
                try managedContext?.save()
                fetchResults.remove(at: indexPath.row)
                inspectionFormTable.deleteRows(at: [indexPath], with: .automatic)
            }
            catch
            {
                print("Couldn't delete the inspection form")
            }
            
            
            /*formList!.removeForm(item: indexPath.row)
        
            self.inspectionFormTable.beginUpdates()
            self.inspectionFormTable.deleteRows(at: [indexPath], with: .automatic)
            self.inspectionFormTable.endUpdates()*/
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
        iModel?.clearData()
        fetchResults.removeAll()
        inspectionFormTable.reloadData()
        /*//enter code to clear all data in table
        formList!.removeAllForms()
        inspectionFormTable.reloadData()*/
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
        
            var wellName = ""
            var date = ""
            var yn = "1"
            var opt = "1"
            
            var i = 0
            //var set = CoreDataHandler.fetchSection()
            
            
            
            var testing = fetchResults[selectedIndex.row].section
            //NSSortDescriptor sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tagN" ascending:YES]
            var ee = (testing?.allObjects as! [InspectionFormCategoryEntity]).sorted(by: {$0.tagN < $1.tagN})
            

            
                //fetchResults[selectedIndex.row].section
            //print(set?.count)
            print(ee.count)
            wellName = fetchResults[selectedIndex.row].wellName!
            date = fetchResults[selectedIndex.row].date!
            while i < ee.count
            {
                if (i > 30)
                {
                    break
                }
                print("i = \(i)")
                print("tagN = \(ee[i].tagN)")
                print("category tagNum = \(ee[i].category?.tagNum)")
                print("category ynAns = \(ee[i].category?.ynAns)")
                print("category optComm = \(ee[i].category?.optComm)")
                //print(set![i].tagN)
                //print(set![i].category?.tagNum)
                //print(set![i].category?.ynAns)
                //print(set![i].category?.optComm)
                //print(set?.count)
                /*print("set[i].tagNum = \(Int(set![i].tagNum))")
                print("set[i].yn = \(set![i].ynAns)")
                print("set[i].optComm = \(set![i].optComm)")*/
                if Int(ee[i].tagN) == 6
                {
                    print("yay")
                    yn = (ee[i].category?.ynAns)!
                    opt = (ee[i].category?.optComm)!
                    break
                }
                
                
                
                
                
                
                
                i += 1
            }
            
            
            //let wellName = formList!.getWellName(item: selectedIndex.row)
            //let date = formList!.getDate(item: selectedIndex.row)
        
        
            //if #available(iOS 14, *) {
                
            let des = segue.destination as! TableCellViewController                //des.indexPath = selectedIndex
                des.iFTitle = wellName
                des.iFDate = date
                des.iFyntext = yn
                des.iFoptcomm = opt
            des.indexPath = selectedIndex
            des.ee = ee
            //} else {
                // Fallback on earlier versions
            //}
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

/*class CoreDataHandler: NSObject
{
    private static func getContext() -> NSManagedObjectContext
    {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return appDelegate
    }
    
    static func fetchSection() -> [InspectionFormCategoryEntity]?
    {
        let context = getContext()
        
        do
        {
            let sections: [InspectionFormCategoryEntity] = try context.fetch(InspectionFormCategoryEntity.fetchRequest())
            return sections
        }
        catch
        {
            return nil
        }
    }
}*/
