//
//  businessRegViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 01/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class businessRegViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var nameOfService: UITextField!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!

    var duration=30
    var servicesData = [Service] ()
    var ref: DatabaseReference! = nil
    var businessLoggedIn=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if businessLoggedIn {self.navigationItem.rightBarButtonItem=nil}
        addBtn.layer.cornerRadius = 10
        addBtn.clipsToBounds = true
        stepper.minimumValue=30
        stepper.maximumValue=120
        stepper.stepValue=30
        ref = Database.database().reference()
        startObserving()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (servicesData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? ServiceTableCell else {return UITableViewCell()}
        cell.serviceLbl.text=servicesData[indexPath.row].nameOfService
        cell.durationLbl.text=servicesData[indexPath.row].duration
        cell.service=servicesData[indexPath.row]
        return cell
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        let currentUser=Auth.auth().currentUser
        if (nameOfService != nil){
            let service = Service(nameOfService: nameOfService.text!, duration: durationLbl.text!)
            let serviceRef=self.ref.child("services").child((currentUser?.uid)!).child((nameOfService.text?.lowercased())!)
            serviceRef.setValue(service.toAnyObject())
        }
    }
    
    func startObserving(){
        let currentUser=Auth.auth().currentUser
        let serviceRef=ref.child("services").child((currentUser?.uid)!).observe(DataEventType.value) { (snapshot) in
            self.servicesData.removeAll()
            for service in snapshot.children
            {
                let serviceObject=Service(snapshot: service as! DataSnapshot)
                self.servicesData.append(serviceObject)
            }
            self.tableView.reloadData()

        }
    }
    
    //servicesToOpenHours
    @IBAction func pressedNext(_ sender: Any) {
        if self.servicesData.isEmpty{
            showMessagePrompt(str: "Please enter at least one Service")
            return
        }
        else
        {
            self.performSegue(withIdentifier: "servicesToOpenHours", sender: nil)
        }
    }
    

    @IBAction func stepperChanged(_ sender: Any) {
        durationLbl.text = Int(stepper.value).description
    }
    
    func showMessagePrompt(str:String)
    {
        print("showing message")
        // create the alert
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
