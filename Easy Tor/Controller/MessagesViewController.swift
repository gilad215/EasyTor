//
//  MessagesViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 11/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessagesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {


    var ref: DatabaseReference! = nil
    var isClient=true
    var chats=[Chat]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? MessagesTableCell else {return UITableViewCell()}
        if isClient
        {
            cell.nameLbl.text=chats[indexPath.row].bname
        }
        else
        {
            cell.nameLbl.text=chats[indexPath.row].cname
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChat=chats[indexPath.row]
        self.performSegue(withIdentifier: "ChatSegue", sender: selectedChat)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observeChats()
    {
        if isClient
        {
            let cref=ref.child("chats").queryOrdered(byChild: "cid").queryEqual(toValue: Auth.auth().currentUser).observe(.value, with: { (snapshot) in
                self.chats.removeAll()
                for chat in snapshot.children
                {
                    let chatObject=Chat(snapshot: chat as! DataSnapshot)
                    self.chats.append(chatObject)
                }
                self.tableView.reloadData()

            })
        }
        else
        {
            let cref=ref.child("chats").queryOrdered(byChild: "bid").queryEqual(toValue: Auth.auth().currentUser).observe(.value, with: { (snapshot) in
                self.chats.removeAll()
                for chat in snapshot.children
            {
                let chatObject=Chat(snapshot: chat as! DataSnapshot)
                self.chats.append(chatObject)
            }
                self.tableView.reloadData()

          })
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.chatkey=chat.key
            if !(isClient)
            {
                chatVc.isClient=false
                chatVc.displayName=chat.bname
                chatVc.ID=chat.bid
            }
            else{
                chatVc.displayName=chat.cname
                chatVc.ID=chat.cid
            }
        }
    }
    
    


}
