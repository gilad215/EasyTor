//
//  ServiceTableCell.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 10/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit


class ServiceTableCell: UITableViewCell {
    
    @IBOutlet var serviceLbl: UILabel!
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!

    var service:Service?
    
    var key:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editPressed(_ sender: Any)
    {
        print("EDIT PRESSED")
    }
    @IBAction func deletePressed(_ sender: Any)
    {
        print("DELETE PRESSED")
    }
}
