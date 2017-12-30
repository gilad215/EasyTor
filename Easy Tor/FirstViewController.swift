//
//  FirstViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 20/12/2017.
//  Copyright © 2017 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FirstViewController: UIViewController {
    var ref: DatabaseReference! = nil
    var events=[Event]()
    var user_name:String!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        let clientuid=Auth.auth().currentUser?.uid
        ref.child("users").child(clientuid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let fname = value?["firstName"] as? String ?? ""
            let lname = value?["lastName"] as? String ?? ""
            self.label1.text="Hello "+fname
            self.user_name=fname+" "+lname
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func addEvent(_ sender: Any) {
        let eventAlert = UIAlertController(title: "Add Event", message: "Enter your event", preferredStyle: .alert)
        eventAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder="Your event"
        }
        
        eventAlert.addAction(UIAlertAction(title:"Send",style:.default,handler:{(action:UIAlertAction) in
            if let eventContent=eventAlert.textFields?.first?.text{
                let event=Event(content: eventContent, addedByUser: self.user_name)
            
            let eventRef=self.ref.child("events").child(eventContent.lowercased())
                eventRef.setValue(event.toAnyObject())
            }
            
        }))
        self.present(eventAlert,animated: true,completion: nil)
    }
    
    func startObserving(){
        ref.observe(DataEventType.value) { (snapshot) in
            var newEvents=[Event]()
            for event in snapshot.children
            {
                let eventObject=Event(snapshot: event as! DataSnapshot)
                newEvents.append(eventObject)
            }
            
            self.events=newEvents
            self.table.reloadData()
        }
    }
    
}
    

    



