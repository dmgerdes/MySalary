//
//  SaleEntryCell.swift
//  MySalary
//
//  Created by Mike Gerdes on 7/17/17.
//  Copyright © 2017 Mike Gerdes. All rights reserved.
//

import UIKit

class SaleEntryCell: UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var sale: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
