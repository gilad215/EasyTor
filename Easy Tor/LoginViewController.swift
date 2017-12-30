//
//  LoginViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 28/12/2017.
//  Copyright © 2017 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PwdTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabVC = storyboard.instantiateViewController(withIdentifier: "tabVC") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController=tabVC
                } else {
                    print("No user")
                }
            }
            else{ print(error)}
        }
    }
    
    @IBAction func RegisterPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let RegVC = storyboard.instantiateViewController(withIdentifier: "RegVC") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController=RegVC
        
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
