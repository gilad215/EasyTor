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

class RegisterViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var pwdTxt: UITextField!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.autocorrectionType = .no
        emailTxt.autocorrectionType = .no
        pwdTxt.autocorrectionType = .no

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
            self.ref.child("users").child((user?.uid)!).setValue(["firstName":fname,"lastName":lname])
            print("Created user!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = storyboard.instantiateViewController(withIdentifier: "tabVC") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController=tabVC
            
        }
        
        
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
