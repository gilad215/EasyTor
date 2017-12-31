//
//  RegisterViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 30/12/2017.
//  Copyright © 2017 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{

    //business
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwdTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var address: UITextField!
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    var category:String!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var businessView: UIView!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.autocorrectionType = .no
        emailTxt.autocorrectionType = .no
        pwdTxt.autocorrectionType = .no
        address.autocorrectionType = .no
        city.autocorrectionType = .no
        self.picker.isHidden=true;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        pickerData = ["Category","Clinic", "Personal Trainer", "Beauty Salon", "Barbershop", "Teacher", "Counselor"]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createAcc(_ sender: Any) {
        ref = Database.database().reference()
        let name=fullName.text?.split(separator: " ")
        let fname=name![0]
        let lname=name![1]
        Auth.auth().createUser(withEmail: emailTxt.text!, password: pwdTxt.text!) { (user, error) in
            self.ref.child("users").child("business").child((user?.uid)!).setValue(["firstName":fname,"lastName":lname,"phone":self.phoneTxt.text,"address":self.address.text,"city":self.city.text,"category":self.category])
            print("Created user!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = storyboard.instantiateViewController(withIdentifier: "tabVC") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController=tabVC
            
        }
        
        
    }
    @IBAction func valuechanged(_ sender: Any) {
        if seg.selectedSegmentIndex == 0
        {
            businessView.isHidden=false
        }
        else { businessView.isHidden=true}
    }
    
    @IBAction func categoryPressed(_ sender: Any) {
        if picker.isHidden==false {
            picker.isHidden=true
        }
        else {picker.isHidden=false}
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
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
    
    
}
