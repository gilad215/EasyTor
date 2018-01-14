//
//  NewChatViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 12/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var businessData: [Business] = [Business]()

    var ref: DatabaseReference! = nil
    var cname:String!
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return businessData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {return UITableViewCell()}
            cell.nameLbl.text=businessData[indexPath.row].name
            cell.addressLbl.text=businessData[indexPath.row].address
            cell.categoryLbl.text=businessData[indexPath.row].category
            return cell
    }
    
    func getList()
    {
            let cref=ref.child("events").queryOrdered(byChild: "cid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(.value, with: { (snapshot) in
                self.businessData.removeAll()
                for event in snapshot.children
                {
                    let valuer = event as! DataSnapshot
                    let dictionary=valuer.value as? NSDictionary
                    
                    let bname = dictionary?["businessName"] as? String ?? ""
                    let baddress = dictionary?["address"] as? String ?? ""
                    let bcategory = dictionary?["businessPhone"] as? String ?? ""
                    let bid = dictionary?["bid"] as? String ?? ""
                    
                    if !(self.businessData.contains(where: { (business) -> Bool in
                        business.key==bid
                    }))
                    {
                    self.businessData.append(Business(name:bname, key:bid,address:baddress,category:bcategory))
                    }
                }
                self.tableView.reloadData()
            })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let cref=ref.child("users").child("clients").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            self.cname=name
            self.getList()
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chatExists:String!
        var chat_key:String!
        let checkref=ref.child("chats").observeSingleEvent(of: .value) { (snapshot) in
            for chat in snapshot.children
            {
                let valuer = chat as! DataSnapshot
                let dictionary=valuer.value as? NSDictionary
                
                let bid = dictionary?["bid"] as? String ?? ""
                let cid = dictionary?["cid"] as? String ?? ""
                if cid==Auth.auth().currentUser?.uid && bid==self.businessData[indexPath.row].key {
                    print("CHAT EXISTS!")
                    chatExists=valuer.key}
                    chat_key=valuer.key
            }
            
            if chatExists==nil
            {
                print("chat doesn't exist")
            let cref=self.ref.child("chats").childByAutoId()
                
                        let chatItem = [
                            "cname":self.cname,
                            "cid":Auth.auth().currentUser?.uid,
                            "bname":self.businessData[indexPath.row].name,
                            "bid":self.businessData[indexPath.row].key
                            ]
                
                        // 3
                        chat_key=cref.key
                        cref.setValue(chatItem)
                let selectedChat=Chat(cid: (Auth.auth().currentUser?.uid)!, bid: self.businessData[indexPath.row].key, cname: self.cname, bname: self.businessData[indexPath.row].name,key:chat_key)
                self.performSegue(withIdentifier: "NewChatSegue", sender: selectedChat)
            }
            else{
                let selectedChat=Chat(cid: (Auth.auth().currentUser?.uid)!, bid: self.businessData[indexPath.row].key, cname: self.cname, bname: self.businessData[indexPath.row].name,key:chatExists)
                self.performSegue(withIdentifier: "NewChatSegue", sender: selectedChat)
            }
        }
        

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController
            
                chatVc.chatkey=chat.key
                chatVc.displayName=chat.cname
                chatVc.ID=chat.cid
            }
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
