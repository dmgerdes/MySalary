//
//  SalesTableVC.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/14/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit
import os.log
import CoreData

class SalesTableVC: UITableViewController {
    var salesEntrys: [SalesEntry] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData() {
        //retreive all entities from SalesEntry
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SalesEntry")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            salesEntrys = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [SalesEntry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return salesEntrys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "saleEntryCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SaleEntryCell  else {
            fatalError("The dequeued cell is not an instance of saleEntryCell.")
        }
        
        //get values
        let sale = salesEntrys[indexPath.row]
        //let dailySale:Double!  = sale.value(forKeyPath: "sales") as? Double
        //let dailyDate: NSDate! = sale.value(forKeyPath: "date") as? NSDate
        
        let dailySale:Double!  = sale.sales
        let dailyDate: NSDate! = sale.date
        
        //format sales
        let nbrformatter = NumberFormatter()
        nbrformatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        nbrformatter.numberStyle = .currency
        if let s = nbrformatter.string(from: dailySale as NSNumber) {
            cell.sale.text = "Sales: \(s)"
        }
        
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: dailyDate as Date)
        
        cell.date.text = dateString
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            managedContext.delete(salesEntrys[indexPath.row])
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
            loadData()
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new sales entry.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let addSalesEntryVC = segue.destination as? AddSalesEntryVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedSalesCell = sender as? SaleEntryCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedSalesCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSalesEntry = salesEntrys[indexPath.row]
            addSalesEntryVC.salesEntry = selectedSalesEntry as? SalesEntry
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //Action
    @IBAction func unwindToSalesEntryList(sender: UIStoryboardSegue) {
        if sender.source is AddSalesEntryVC{
            loadData()
            tableView.reloadData()
        }
    }
}
