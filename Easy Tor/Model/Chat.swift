
import Foundation
import FirebaseDatabase

struct Chat {
    
    let key:String!
    let cid:String!
    let bid:String!
    let cname:String!
    let bname:String!
    let date:String!
    let lastTxt:String!
    let ref: DatabaseReference!
    
    init (cid:String, bid:String,cname:String,bname:String,key:String="",date:String="",lastTxt:String="") {
        self.key=key
        self.cid = cid
        self.bid = bid
        self.cname=cname
        self.bname=bname
        self.date=date
        self.lastTxt=lastTxt
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
        let date = value?["date"] as? String ?? ""
        let lastTxt = value?["text"] as? String ?? ""
        
        self.cname=cname
        self.cid=cid
        self.bname=bname
        self.bid=bid
        self.date=date
        self.lastTxt=lastTxt
        print("CHAT ADDED")
        
    }
    
    func toAnyObject() -> Any {
        return ["cname":cname, "cid":cid,"bname":bname,"bid":bid,"date":date,"text":lastTxt]
    }
}
