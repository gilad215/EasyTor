//
//  Business.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 02/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Business {
    
    let key:String!
    let name:String!
    let address:String!
    let city:String!
    let phone:String!
    let category:String!
    let ref: DatabaseReference!
    
    init (name:String, key:String = "",address:String="",city:String="",phone:String="",category:String="") {
        self.key = key
        self.name = name
        self.address = address
        self.city=city
        self.phone=phone
        self.category=category
        self.ref = Database.database().reference()
    }
    
    init (snapshot:DataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        self.name = value?["businessName"] as? String ?? ""
        self.address = value?["address"] as? String ?? ""
        self.city = value?["city"] as? String ?? ""
        self.category = value?["category"] as? String ?? ""
        self.phone = value?["phone"] as? String ?? ""
        
    }
    
    func toAnyObject() -> Any {
        return ["businessName":name, "address":address,"city":city,"phone":phone,"category":category]
    }
}
