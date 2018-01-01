//
//  OpeningHoursViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 01/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit

class OpeningHoursViewController: UIViewController {

    @IBOutlet weak var sunday_open: UIButton!
    @IBOutlet weak var sunday_closed: UIButton!
    @IBOutlet weak var monday_open: UIButton!
    @IBOutlet weak var monday_closed: UIButton!
    @IBOutlet weak var tuesday_open: UIButton!
    @IBOutlet weak var tuesday_closed: UIButton!
    @IBOutlet weak var wednesday_open: UIButton!
    @IBOutlet weak var wednesday_closed: UIButton!
    @IBOutlet weak var thursday_open: UIButton!
    @IBOutlet weak var thursday_closed: UIButton!
    @IBOutlet weak var friday_open: UIButton!
    @IBOutlet weak var friday_closed: UIButton!
    @IBOutlet weak var saturday_open: UIButton!
    @IBOutlet weak var saturday_closed: UIButton!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    
    
    @IBAction func daySwitched(_ sender: UISwitch) {
        if sender.isOn
        {
        if sender.tag==1
        {
            sunday_open.isHidden=false
            sunday_closed.isHidden=false
        }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sunday_open.isHidden=true
        sunday_closed.isHidden=true
        monday_open.isHidden=true
        monday_closed.isHidden=true
        tuesday_open.isHidden=true
        tuesday_closed.isHidden=true
        wednesday_open.isHidden=true
        wednesday_closed.isHidden=true
        thursday_open.isHidden=true
        thursday_closed.isHidden=true
        friday_open.isHidden=true
        friday_closed.isHidden=true
        saturday_open.isHidden=true
        saturday_closed.isHidden=true
        timePicker.isHidden=true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressedTime(_ sender: UIButton) {
        timePicker.datePickerMode = .time
        timePicker.isHidden=false
        sender.setTitle(timePicker.date.description, for: .normal)
        
        
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
