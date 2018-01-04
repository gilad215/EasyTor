//
//  AddViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 03/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var category:String!
    
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var tableViewServices: UITableView!
    
    
    var pickerData: [String] = [String]()
    var ref: DatabaseReference! = nil
    var businessData: [Business] = [Business]()
    var servicesData: [Service] = [Service]()

    @IBOutlet weak var searchBusinessView: UIView!
    @IBOutlet weak var servicesView: UIView!
    var selectedBusiness:String!
    @IBOutlet weak var selectedBusinessName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicesView.isHidden=true
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
        if tableView==tableVIew {
            return businessData.count}
        if tableView==tableViewServices
        {
            return servicesData.count
        }
        return 1    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if tableView==tableVIew
        {
            guard let tablecell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{return UITableViewCell()}
            tablecell.nameLbl.text=businessData[indexPath.row].name
            tablecell.addressLbl.text=businessData[indexPath.row].address
            tablecell.categoryLbl.text=businessData[indexPath.row].category
            tablecell.key=businessData[indexPath.row].key
            return tablecell
        }
        if tableView==tableViewServices
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = servicesData[indexPath.row].nameOfService+" "+servicesData[indexPath.row].duration
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView==tableVIew
        {
            let currentCell = tableView.cellForRow(at: indexPath) as! TableCell
            selectedBusiness=currentCell.key
            selectedBusinessName.text=currentCell.nameLbl.text
        }
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
                self.tableVIew.reloadData()
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
    
    
    @IBAction func nextPressed(_ sender: Any) {
        if selectedBusiness.isEmpty==false
        {
            searchBusinessView.isHidden=true
            servicesView.isHidden=false
            let qref=ref.child("services")
            qref.child(selectedBusiness).observe(DataEventType.value, with: { (snapshot) in
                print("SERVICES SNAPSHOT")
                print(snapshot)
                for service in snapshot.children
                {
                    let serviceObject=Service(snapshot: service as! DataSnapshot)
                    self.servicesData.append(serviceObject)
                }
                self.tableViewServices.reloadData()
            })
        }
    }
    
    /*
     
     @IBAction func nextPressed(_ sender: Any) {
     }
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
