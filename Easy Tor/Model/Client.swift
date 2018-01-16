
import Foundation
import FirebaseDatabase

struct Client {
    
    let key:String!
    let name:String!
    let address:String!
    let city:String!
    let phone:String!
    let ref: DatabaseReference!
    
    init (name:String, key:String = "",address:String="",city:String="",phone:String="") {
        self.key = key
        self.name = name
        self.address = address
        self.city=city
        self.phone=phone
        self.ref = Database.database().reference()
    }
    
    init (snapshot:DataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        self.name = value?["name"] as? String ?? ""
        self.address = value?["address"] as? String ?? ""
        self.city = value?["city"] as? String ?? ""
        self.phone = value?["phone"] as? String ?? ""
        
    }
    
    func toAnyObject() -> Any {
        return ["name":name, "address":address,"city":city,"phone":phone]
}
    
}
