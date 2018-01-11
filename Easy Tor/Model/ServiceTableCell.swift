//
//  ServiceTableCell.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 10/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ServiceTableCell: UITableViewCell {
    
    @IBOutlet var serviceLbl: UILabel!
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    var ref: DatabaseReference! = nil

    var service:Service?
    
    var key:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deletePressed(_ sender: Any)
    {
        ref = Database.database().reference()
        print("DELETE PRESSED"); self.ref.child("services").child((Auth.auth().currentUser?.uid)!).child((service?.nameOfService)!).removeValue { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                print("Child Removed Correctly")
            }
        }
    }
}
