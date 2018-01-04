//
//  TableCell.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 02/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    var key:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
