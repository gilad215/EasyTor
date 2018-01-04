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
    
    @IBOutlet weak var duration: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfServices = [Service] ()
    var ref: DatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        startObserving()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfServices.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = listOfServices[indexPath.row].nameOfService+" "+listOfServices[indexPath.row].duration
        
        return (cell)
    }

    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        let currentUser=Auth.auth().currentUser
        if (nameOfService != nil) && (duration != nil){
            let service = Service(nameOfService: nameOfService.text!, duration: duration.text!)
            let serviceRef=self.ref.child("services").child((currentUser?.uid)!).child((nameOfService.text?.lowercased())!)
            serviceRef.setValue(service.toAnyObject())
        }
    }
    
    func startObserving(){
        let currentUser=Auth.auth().currentUser
        let serviceRef=ref.child("services").child((currentUser?.uid)!).observe(DataEventType.value) { (snapshot) in
            self.listOfServices.removeAll()
            for service in snapshot.children
            {
                print(service)
                let serviceObject=Service(snapshot: service as! DataSnapshot)
                self.listOfServices.append(serviceObject)
            }
            self.tableView.reloadData()

        }
    }
    
    
    @IBAction func finishPressed(_ sender:
        Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let openhoursVC = storyboard.instantiateViewController(withIdentifier: "openhoursVC") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController=openhoursVC
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
