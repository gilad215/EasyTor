//
//  LoginViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 28/12/2017.
//  Copyright © 2017 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PwdTxt: UITextField!
    var ref: DatabaseReference! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func loginPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: EmailTxt.text!, password: PwdTxt.text!) { (user, error) in
            if error==nil{
                print("Login success!")
                if Auth.auth().currentUser != nil {
                    print((Auth.auth().currentUser?.email)!+" is logged in!\nMoving to the tab view..")
                    
                    self.ref.child("users").child("business").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild((Auth.auth().currentUser?.uid)!)
                        {
                            print("BUSINESS LOGGED")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabVC = storyboard.instantiateViewController(withIdentifier: "businessTabVC") as! UITabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController=tabVC
                        }
                        else{
                            print("CLIENT LOGGED")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabVC = storyboard.instantiateViewController(withIdentifier: "tabVC") as! UITabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController=tabVC
                        }
                    })
                    
                } else {
                    print("No user")
                }
            }
            else{ print(error)}
        }
    }
    
    @IBAction func RegisterPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "navVC") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController=navVC
        
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
