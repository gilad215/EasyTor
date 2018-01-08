//
//  ChooseServicesViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 04/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChooseServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var selectTimeBtn: UIButton!
    @IBOutlet weak var dateTimePicker: UIPickerView!
    //date
    let date=Date()
    var calendar = Calendar.current
    let formatter = DateFormatter()
    
    var businessUid:String?
    var ref: DatabaseReference! = nil
    var servicesData: [Service] = [Service]()
    var openDays=["sunday","monday","tuesday","wednesday","thursday","friday","saturday"]
    var filteredOpenDays:[Int] = [Int]()
    var filteredDaysString:[String] = [String]()
    var selectedService:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getOpenDays()
        dateTimePicker.isHidden=true
        self.dateTimePicker.dataSource = self;
        self.dateTimePicker.delegate = self;
        let compontents = Calendar.current.dateComponents([.month,.day], from: date)
        navbarItem.title="Choose a Service"
        selectTimeBtn.isHidden=true
        formatter.dateFormat = "MM-dd"
        loadTable()
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
                    let filtereday=i+1
                    self.filteredOpenDays.append(filtereday)
                }
            }
            print(self.openDays)
            let weekdayFormatter=DateFormatter()
            weekdayFormatter.dateFormat="EEEE"
            
            var week1:[String]=[String]()
            var week2:[String]=[String]()
            var nextWeek:Date?
            
            for openday in self.filteredOpenDays
            {
                print(openday)
                let newdate=self.calendar.nextDate(after: self.date, matching: DateComponents(weekday:openday), matchingPolicy: .nextTime)
                nextWeek=newdate
                var dayInWeek=weekdayFormatter.string(from: newdate!)
                var month = String(self.calendar.component(.month, from: newdate!))
                var day = String(self.calendar.component(.day, from: newdate!))
                let finalDate=dayInWeek+" "+day+"/"+month
                week1.append(finalDate)

            }
            for openday in self.filteredOpenDays
            {
                print(openday)
                let newdate=self.calendar.nextDate(after: nextWeek!, matching: DateComponents(weekday:openday), matchingPolicy: .nextTime)
                
                var dayInWeek=weekdayFormatter.string(from: newdate!)
                var month = String(self.calendar.component(.month, from: newdate!))
                var day = String(self.calendar.component(.day, from: newdate!))
                let finalDate=dayInWeek+" "+day+"/"+month
                week2.append(finalDate)
            }
            self.filteredDaysString.append(contentsOf: week1)
            self.filteredDaysString.append(contentsOf: week2)
            print(self.filteredDaysString)
//            let weekafter=self.calendar.nextDate(after: newdate!, matching: DateComponents(weekday:openday), matchingPolicy: .nextTime)
//            dayInWeek=weekdayFormatter.string(from: weekafter!)
//            self.filteredDaysString.append(dayInWeek)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredDaysString.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectDateBtn.setTitle(filteredDaysString[row], for:.normal)
        //category=pickerData[row]
        return filteredDaysString[row]
    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//
//        self.view.endEditing(false)
//        dateTimePicker.selectRow(0, inComponent: 0, animated: true)
//        dateTimePicker.reloadAllComponents();
//
//    }

    @IBAction func datePressed(_ sender: Any) {
        dateTimePicker.isHidden=false
        dateTimePicker.reloadAllComponents();

        
    }
    
    
}
