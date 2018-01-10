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
        self.date=date
        self.ref = Database.database().reference()
    }
    
    init (snapshot:DataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        let event = value?["content"] as? String ?? ""
        let date = value?["date"] as? String ?? ""
        let addedby = value?["addedByUser"] as? String ?? ""
        
        self.service=event
        print("Content of event:"+self.service)
        self.date=date
        self.addedByUser=addedby
        
        
    }
    
    func toAnyObject() -> Any {
        return ["content":service, "addedByUser":addedByUser]
}
}

//event
