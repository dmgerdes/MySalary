//
//  TotalsCell.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/20/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit

class TotalsCell: UITableViewCell {
    
    @IBOutlet weak var totalEarned: UILabel!
    @IBOutlet weak var totalSales: UILabel!
    @IBOutlet weak var daysWorked: UILabel!
    @IBOutlet weak var bonusEarned: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
