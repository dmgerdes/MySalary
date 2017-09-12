//
//  SalaryCell.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/18/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit

class SalaryCell: UITableViewCell {
    
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var salaryGoal: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var salaryBonus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
