//
//  AddViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 03/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var category:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navbarHead: UINavigationItem!
    
    var pickerData: [String] = [String]()
    var ref: DatabaseReference! = nil
    var businessData: [Business] = [Business]()
    var servicesData: [Service] = [Service]()

    @IBOutlet weak var searchBusinessView: UIView!
    @IBOutlet weak var servicesView: UIView!
    var selectedBusiness:String?
    var selectedBusinessName:String?
    var selectedService:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.pickerView.isHidden=true;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        pickerData = ["Category","Clinic", "Personal Trainer", "Beauty Salon", "Barbershop", "Teacher", "Counselor"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return businessData.count   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let tablecell=tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as? TableCell else{return UITableViewCell()}
            tablecell.nameLbl.text=businessData[indexPath.row].name
            tablecell.addressLbl.text=businessData[indexPath.row].address
            tablecell.categoryLbl.text=businessData[indexPath.row].category
            tablecell.key=businessData[indexPath.row].key
            return tablecell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let currentCell = tableView.cellForRow(at: indexPath) as! TableCell
            selectedBusiness=currentCell.key
            selectedBusinessName=currentCell.nameLbl.text
    }
    

    @IBAction func categoryPressed(_ sender: Any) {
        if pickerView.isHidden==false {
            pickerView.isHidden=true
            let qref=ref.child("users").child("business")
            qref.queryOrdered(byChild: "category").queryEqual(toValue: category).observe(DataEventType.value) { (snapshot) in
               self.businessData.removeAll()
                for business in snapshot.children
                {
                    let businessObject=Business(snapshot:business as! DataSnapshot)
                    self.businessData.append(businessObject)
                }
                self.tableView.reloadData()
            }
            
        }
        else {pickerView.isHidden=false}
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categoryBtn.setTitle(pickerData[row], for:.normal)
        category=pickerData[row]
        
        
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chooseServiceVC=segue.destination as? ChooseServicesViewController {
            print("sending business...")
            print(selectedBusiness)
            chooseServiceVC.businessUid=selectedBusiness
            chooseServiceVC.clientUid=Auth.auth().currentUser?.uid
        }
    }

}
