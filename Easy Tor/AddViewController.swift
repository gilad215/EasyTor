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
    var pickerData: [String] = [String]()
    var ref: DatabaseReference! = nil
    var businessData: [Business] = [Business]()
    
    
    
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
        return businessData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{return UITableViewCell()}
        cell.nameLbl.text=businessData[indexPath.row].name
        cell.addressLbl.text=businessData[indexPath.row].address
        cell.categoryLbl.text=businessData[indexPath.row].category
        return cell
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
    
    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
