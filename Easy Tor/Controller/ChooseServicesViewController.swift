//
//  ChooseServicesViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 04/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChooseServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var selectTimeBtn: UIButton!
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var serviceLabel: UILabel!
    
    var businessUid:String?
    var ref: DatabaseReference! = nil
    var servicesData: [Service] = [Service]()
    var openDays=["sunday","monday","tuesday","wednesday","thursday","friday","saturday"]
    var selectedService:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        navbarItem.title="Choose a Service"

        loadTable()
        getOpenDays()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = servicesData[indexPath.row].nameOfService
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
            serviceLabel.text="Schedule the Service: "+(currentCell.textLabel?.text)!
            selectedService=currentCell.textLabel?.text
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTable()
    {
        ref.child("services").child(businessUid!).observe(DataEventType.value) { (snapshot) in
            self.servicesData.removeAll()
            for service in snapshot.children
            {
                let serviceObject=Service(snapshot:service as! DataSnapshot)
                self.servicesData.append(serviceObject)
            }
            self.tableView.reloadData()
        }
    }

    func getOpenDays()
    {
        let qref=ref.child("openhours").child(businessUid!).observe(DataEventType.value) { (snapshot) in
            for var i in (0..<self.openDays.count)
            {
                if snapshot.hasChild(self.openDays[i])
                {
                    print("found day",self.openDays[i])
                    self.openDays[i]="1"
                }
            }
            print(self.openDays)
        }
    }
}
