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
    let bname:String!
    let bphone:String!
    let baddress:String!
    let ref: DatabaseReference!
    
    init (service:String, bid:String, key:String = "",cid:String,time:String,date:String="",bname:String,bphone:String,baddress:String) {
        self.key = key
        self.service = service
        self.bid = bid
        self.cid = cid
        self.date = date
        self.time = time
        self.bname=bname
        self.bphone=bphone
        self.baddress=baddress
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
        let bname = value?["businessName"] as? String ?? ""
        let bphone = value?["businessPhone"] as? String ?? ""
        let baddress = value?["address"] as? String ?? ""


        self.service=service
        self.bid = bid
        self.cid = cid
        self.date = date
        self.time = time
        self.bname=bname
        self.baddress=baddress
        self.bphone=bphone
    }
    
    func toAnyObject() -> Any {
        return ["service":service, "bid":bid,"cid":cid,"date":date,"time":time,"businessName":bname,"businessPhone":bphone,"address":baddress]
}
}

//event
