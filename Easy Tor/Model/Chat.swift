//
//  Chat.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 12/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Chat {
    
    let key:String!
    let cid:String!
    let bid:String!
    let cname:String!
    let bname:String!
    let ref: DatabaseReference!
    
    init (cid:String, bid:String,cname:String,bname:String,key:String="") {
        self.key=key
        self.cid = cid
        self.bid = bid
        self.cname=cname
        self.bname=bname
        self.ref = Database.database().reference()
    }
    
    init (snapshot:DataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        let cid = value?["cid"] as? String ?? ""
        let bid = value?["bid"] as? String ?? ""
        let cname = value?["cname"] as? String ?? ""
        let bname = value?["bname"] as? String ?? ""
        
        self.cname=cname
        self.cid=cid
        self.bname=bname
        self.bid=bid
        
        
    }
    
    func toAnyObject() -> Any {
        return ["cname":cname, "cid":cid,"bname":bname,"bid":bid]
    }
}
