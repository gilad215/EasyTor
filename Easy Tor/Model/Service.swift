//
//  Service.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 01/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Service {
    
    let key:String!
    let nameOfService:String!
    let duration:String!
    let ref: DatabaseReference!
    
    init (nameOfService:String, key:String = "",duration:String="") {
        self.key = key
        self.nameOfService = nameOfService
        self.duration = duration
        self.ref = Database.database().reference()
    }
    
    init (snapshot:DataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        let service = value?["name of Service"] as? String ?? ""
        let duration = value?["duration"] as? String ?? ""
        
        
        self.nameOfService=service
        print("Content of service:"+self.nameOfService)
        self.duration=duration
        
        
    }
    
    func toAnyObject() -> Any {
        return ["name of Service":nameOfService, "duration":duration]
    }
}

//event
