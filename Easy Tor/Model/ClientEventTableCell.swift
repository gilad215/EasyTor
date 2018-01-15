//
//  ClientEventTableCell.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 11/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import SQLite

class ClientEventTableCell: UITableViewCell {
    
    var delegate:MyCustomCellDelegator!
    var database:Connection!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    var ref: DatabaseReference! = nil
    
    
    var eventKey:String?
    var businessid:String?
    var chatExists:String!
    var chat_key:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        ref = Database.database().reference()
        do
        {
            let documentDirectory=try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl=documentDirectory.appendingPathComponent("events").appendingPathExtension("sqlite3")
            let database=try Connection(fileUrl.path)
            self.database=database
        }
        catch
        {
            print(error)
        }

        // Initialization code
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //chatBtnSegue
    @IBAction func chatPressed(_ sender: Any) {
        let checkref=ref.child("chats").observeSingleEvent(of: .value) { (snapshot) in
        for chat in snapshot.children
        {
            let valuer = chat as! DataSnapshot
            let dictionary=valuer.value as? NSDictionary
            
            let bid = dictionary?["bid"] as? String ?? ""
            let cid = dictionary?["cid"] as? String ?? ""
            if cid==Auth.auth().currentUser?.uid && bid==self.businessid {
                print("CHAT EXISTS!")
                self.chatExists=valuer.key}
                self.chat_key=valuer.key
        }
        
        if self.chatExists==nil
        {
            print("chat doesn't exist")
            let cref=self.ref.child("chats").childByAutoId()
            
            let chatItem = [
                //"cname":self.cname,
                "cid":Auth.auth().currentUser?.uid,
                "bname":self.businessName.text!,
                "bid":self.businessid
            ]
            
            // 3
            self.chat_key=cref.key
            cref.setValue(chatItem)
            let selectedChat=Chat(cid: (Auth.auth().currentUser?.uid)!, bid: self.businessid!, cname: "john", bname: self.businessName.text!,key:self.chat_key)
            if(self.delegate != nil){ //Just to be safe.
                self.delegate.callSegueFromCell(myData:selectedChat as AnyObject)
            }
        }
            else
        {
            let selectedChat=Chat(cid: (Auth.auth().currentUser?.uid)!, bid: self.businessid!,cname:" ", bname: self.businessName.text!,key:self.chatExists)
            if(self.delegate != nil){ //Just to be safe.
                self.delegate.callSegueFromCell(myData:selectedChat as AnyObject)
            }
        
    }
    }
    }
    
    
    @IBAction func deletePressed(_ sender: Any)
    {
        print("BUSINESS KEY FOR ADDING HOURS:")
        print(self.businessid)
        ref = Database.database().reference()
        print("DELETE PRESSED")
        self.ref.child("events").child(eventKey!).removeValue { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                print("Child Removed Correctly")

            self.ref.child("availablehours").child(self.businessid!).child("services").child(self.serviceName.text!).child(self.dateLbl.text!).child(self.timeLbl.text!).updateChildValues(["time":self.timeLbl.text!])
            }
        }
        
        
    }
    
  
}

