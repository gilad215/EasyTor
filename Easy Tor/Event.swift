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
    let content:String!
    let date:String!
    let addedByUser:String!
    let ref: DatabaseReference!
    
    init (content:String, addedByUser:String, key:String = "",date:String="") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
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
        
        self.content=event
        print("Content of event:"+self.content)
        self.date=date
        self.addedByUser=addedby
        
        
    }
    
    func toAnyObject() -> Any {
        return ["content":content, "addedByUser":addedByUser]
}
}

//event
