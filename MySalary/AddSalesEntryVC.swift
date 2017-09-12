//
//  ViewController.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/5/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit
import CoreData
import os.log

class AddSalesEntryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var salaryPicker: UIPickerView!
    
    var salesEntry:SalesEntry?
    var salaries: [Salary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get possible salaries
        self.salaryPicker.delegate = self
        self.salaryPicker.dataSource = self
        getSalaries()
        
        // Set up views if editing an existing Meal.
        if let salesEntry = salesEntry {
            datePicker.date = salesEntry.date! as Date
            
            //if let s = salesEntry.sales {
                salaryTextField.text = String(describing: salesEntry.sales)
            //}
            
            let salary = salesEntry.salary
            
            if salary != nil {
                salaryPicker.selectRow(getSalaryIndex(salary: salary!), inComponent: 0, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getSalaryIndex(salary:Salary) -> Int {
        var index:Int = 0
                
        //match salary in array or return 0
        for (idx,s) in salaries.enumerated() {
            if s == salary{
                index = idx
                break
            }
        }
        
        
        return index
    }
    
    
    func getSalaries() {
        //retreive all entities from SalesEntry
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Salary")
        
        let sortDescriptor = NSSortDescriptor(key: "locName", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            salaries = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Salary]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save() {
        //save data to SalesEntry coredata
        os_log("Save sales entry.", log: OSLog.default, type: .debug)
        
        let date = datePicker.date
        let salesText = salaryTextField.text ?? ""
        let sales = Double(salesText)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "SalesEntry",
                                       in: managedContext)!
        
        
        if salesEntry == nil {
            salesEntry = NSManagedObject(entity: entity,
                                              insertInto: managedContext) as? SalesEntry
        }
        
        //salesEntry?.setValue(salary, forKeyPath: "sales")
        //salesEntry?.setValue(date, forKeyPath: "date")
        
        salesEntry?.sales = sales!
        salesEntry?.date = date as NSDate
        
        let selectedSalary = self.salaryPicker.selectedRow(inComponent: 0)
        //let salaryRelationship = salesEntry?.mutableSetValue(forKey: "salary")
        //salaryRelationship?.add(salaries[selectedSalary])
        salesEntry?.salary = salaries[selectedSalary]
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //MARK: PickerView
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salaries.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let salary = salaries[row]
        var locationName:String = ""
        
        if let l = salary.value(forKeyPath: "locName") {
            locationName = String(describing:l)
        }
        
        return locationName
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddSalesMode = (self.presentingViewController != nil)
        
        if isPresentingInAddSalesMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The AddSalaryViewController is not inside a navigation controller.")
        }
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        save()
    }

}

