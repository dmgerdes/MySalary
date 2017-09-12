//
//  SalesEntry.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/18/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit

class Sale {
    
    //MARK: Properties
    
    var sales: Double
    var date: NSDate
    
    //MARK: Initialization
    
    init?(sales: Double, date: NSDate) {
        //do i need a sales check?
        // The sales must not be empty
        //guard !sales.isEmpty else {
        //    return nil
        //}
        
        //date check?
        
        // Initialize stored properties.
        self.sales = sales
        self.date = date
        
    }
}
