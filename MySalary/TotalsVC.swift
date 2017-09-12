//
//  Totals2VC.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/20/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit
import CoreData

class TotalsVC: UITableViewController {
    var salaries: [Salary] = []
    var salesEntries: [SalesEntry] = []
    var monthlyTotalSales:Double = 0.0
    var monthlyTotalEarned:Double = 0.0
    var monthlyTotalBonus:Double = 0.0
    var yearlyTotalEarned:Double = 0.0
    var yearlyProjections:Double = 0.0
    var totalDaysWorked:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        monthlyTotalSales = 0.0
        monthlyTotalEarned = 0.0
        monthlyTotalBonus = 0.0
        yearlyTotalEarned = 0.0
        yearlyProjections = 0.0
        totalDaysWorked = 0.0
        
        salaries = []
        salesEntries = []
        
        loadSalaries()
        loadYearlyTotal()
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //adding 1 to put 'Total' at the end of salaries
        if(section == salaries.count) {
            return "Total"
        }
        
        return salaries[section].locName
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // take the total number of salaries plus 1 to include all
        return (salaries.count + 1)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "totalsCell"
        var bonusTotal = 0.0
        var salesTotal = 0.0
        var totalEarned = 0.0
        var daysWorked = 0.0
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TotalsCell  else {
            fatalError("The dequeued cell is not an instance of totalsCell.")
        }
        
        //currency formater
        let nbrformatter = NumberFormatter()
        nbrformatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        nbrformatter.numberStyle = .currency
        
        //percent formatter
        let percentformatter = NumberFormatter()
        percentformatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        percentformatter.numberStyle = .percent
        percentformatter.multiplier = 1
        
        //add 1 section for Totals
        if indexPath.section == salaries.count {
        
            //cell data
            cell.daysWorked.text = "Days Worked:\n\(totalDaysWorked)"
            
            if let y = nbrformatter.string(from: yearlyTotalEarned as NSNumber) {
                cell.totalSales.text = "Yearly Total Earned:\n\(y)"
            }
            
            if let b = nbrformatter.string(from: monthlyTotalBonus  as NSNumber) {
                cell.bonusEarned.text = "Monthly Total Bonus:\n\(b)"
            }
            
            if let t = nbrformatter.string(from: monthlyTotalEarned  as NSNumber) {
                cell.totalEarned.text = "Monthly Total Earned:\n\(t)"
            }
        } else {
            
            
            let currentDate = Calendar.current.dateComponents([.month,.year], from: Date())
            print("currentdate = \(currentDate)")
            //month = calendar.component([.month,.year], from: date as Date)
            
            //get values
            let salary = salaries[indexPath.section]
            let salarySalesEntries = salary.salesEntry?.allObjects as! [SalesEntry]
            let salarySalesEntriesForThisMonth = salarySalesEntries.filter({ (salesEntry) -> Bool in
                if(Calendar.current.dateComponents([.month,.year], from: salesEntry.date! as Date)  == currentDate) {
                    return true
                }
                return false
            })
            
            //let salarySalesEntriesForThisMonth = salarySalesEntries.filter{ _ in (Calendar.current.dateComponents([.month,.year], from: $1.date as Date)  == currentDate) }
            //let salarySalesEntriesForThisMonth = salarySalesEntries.filter(
            //    Calendar.current.date($1.date, matchesComponents: Calendar.dateComponents([.month,.year],from: Date()))
            //)
            
            daysWorked = Double(salarySalesEntriesForThisMonth.count)
            salesTotal = salarySalesEntriesForThisMonth.reduce(0,{$0 + $1.sales})
            
            //final calcs
            bonusTotal = (salesTotal - (daysWorked * salary.goal)) * (salary.bonus / 100)
            if bonusTotal < 0 {
                bonusTotal = 0
            }
            totalEarned = (salary.salary * daysWorked) + bonusTotal
            
            //save for totals row
            monthlyTotalEarned += totalEarned
            totalDaysWorked += daysWorked
            monthlyTotalBonus += bonusTotal
            
            //cell data
            cell.daysWorked.text = "Days Worked:\n\(daysWorked)"
            
            if let s = nbrformatter.string(from: salesTotal as NSNumber) {
                cell.totalSales.text = "Monthly Sales:\n\(s)"
            }
            
            if let b = nbrformatter.string(from: bonusTotal  as NSNumber) {
                cell.bonusEarned.text = "Monthly Total Bonus:\n\(b)"
            }
            
            if let t = nbrformatter.string(from: totalEarned  as NSNumber) {
                cell.totalEarned.text = "Monthly Total Earned:\n\(t)"
            }
            
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Data
    func loadSalaries() {
        
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
            salaries.append(contentsOf: try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Salary])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadYearlyTotal() {
        
        //retreive all entities from SalesEntry
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SalesEntry")
        
        // Set calendar and get year
        let calendar = Calendar.current
        let year = Calendar.current.component(.year, from: Date())
        
        // Get first day of year
        let firstDayComponents = DateComponents(year: year, month: 1, day: 1)
        let firstDay = calendar.date(from: firstDayComponents)!
        
        // Get last day of year
        let lastDayComponents = DateComponents(year: year, month: 12, day: 31)
        let lastDay = calendar.date(from: lastDayComponents)!
        
        // Set date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        // Print results
        //print(dateFormatter.string(from: year))
        print(dateFormatter.string(from: firstDay))
        print(dateFormatter.string(from: lastDay))
        
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", firstDay as CVarArg, lastDay as CVarArg)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        
        //fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        do {
            salesEntries = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [SalesEntry]
            
            
            // total
            //need to organize monthly data since salaries may vary and affect montly total
            var mAry = [Salary: [Double]]()
            var yTotal = 0.0
            var month = 0
            var currentMonth = 0
            var date: NSDate!
            let calendar = Calendar.current
            
            
            for sales in salesEntries {
                
                //detect month, calc totals, and reset
                date = sales.date
                month = calendar.component(.month, from: date as Date)
                print("month = \(month)")
                if(month != currentMonth) {
                    //calc monthly totals for prev months not including last month
                    if mAry.count > 0 {
                        yTotal += calcMonthlyTotals(monthlySales: mAry) //save to yearly total
                    }
                    
                    //save month and reset
                    currentMonth = month
                    mAry = [Salary: [Double]]()
                }
                //add or create montly totals
                if mAry[sales.salary!] != nil {
                    mAry[sales.salary!]?.append(sales.sales)
                } else {
                    mAry[sales.salary!] = [sales.sales]
                }
            }
            //calc last month
            yTotal += calcMonthlyTotals(monthlySales: mAry)
            
            yearlyTotalEarned = yTotal
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func calcMonthlyTotals(monthlySales:[Salary: [Double]]) -> Double {
        var daysWorked = 0.0
        var salesTotal = 0.0
        var bonusTotal = 0.0
        var totalEarned = 0.0
        
        for s in monthlySales {
            
            daysWorked = Double(s.value.count)
            salesTotal = s.value.reduce(0,{$0 + $1})
            
            bonusTotal = (salesTotal - (daysWorked * s.key.goal)) * (s.key.bonus / 100)
            if bonusTotal < 0 {
                bonusTotal = 0
            }
            totalEarned += (s.key.salary * daysWorked) + bonusTotal
        }
        
        return totalEarned
        
    }

}
