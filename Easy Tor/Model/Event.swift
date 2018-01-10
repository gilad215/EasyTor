//
//  Event.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 30/12/2017.
//  Copyright © 2017 Gilad Lekner. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Event {
    
    let key:String!
    let service:String!
    let date:String!
    let time:String!
    let bid:String!
    let cid:String!
    let ref: DatabaseReference!
    
    init (service:String, bid:String, key:String = "",cid:String,time:String,date:String="") {
        self.key = key
        self.service = service
        self.bid = bid
        self.cid = cid
        self.date = date
        self.time = time
        self.ref = Database.database().reference()
    }
    
    init (snapshot:DataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        let service = value?["service"] as? String ?? ""
        let date = value?["date"] as? String ?? ""
        let bid = value?["bid"] as? String ?? ""
        let cid = value?["cid"] as? String ?? ""
        let time = value?["time"] as? String ?? ""

        self.service=service
        self.bid = bid
        self.cid = cid
        self.date = date
        self.time = time
    }
    
    func toAnyObject() -> Any {
        return ["service":service, "bid":bid,"cid":cid,"date":date,"time":time]
}
}

//event
