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
    
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var event3: UILabel!
    
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
        startObserving()
        
        
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
        ref.child("events").observe(DataEventType.value) { (snapshot) in
            var newEvents=[Event]()
            for event in snapshot.children
            {
                let eventObject=Event(snapshot: event as! DataSnapshot)
                newEvents.append(eventObject)
            }
            
            self.events=newEvents
            print("events size:",self.events.count);
            self.event1.text=self.events[0].content+" "+self.events[0].date
            self.event2.text=self.events[1].content+" "+self.events[1].date
            //self.event3.text=self.events[2].content+" "+self.events[2].date

        }
    }
    
}
    

    



