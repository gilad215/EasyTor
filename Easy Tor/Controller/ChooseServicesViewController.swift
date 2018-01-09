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
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var selectTimeBtn: UIButton!
    @IBOutlet weak var dateTimePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
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
    var openDaysFinal:[String] = [String]()
    
    var availableHours:[String] = [String]()
    
    var selectedService:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getOpenDays()
        dateTimePicker.isHidden=true
        timePicker.isHidden=true
        self.dateTimePicker.dataSource = self;
        self.dateTimePicker.delegate = self;
        self.timePicker.delegate = self;
        self.timePicker.dataSource = self;
        let compontents = Calendar.current.dateComponents([.month,.day], from: date)
        navbarItem.title="Choose a Service"
        selectTimeBtn.isHidden=true
        formatter.dateFormat = "MM-dd"
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
            for service in snapshot.children
            {
                let serviceObject=Service(snapshot:service as! DataSnapshot)
                self.servicesData.append(serviceObject)
            }
            self.tableView.reloadData()
            self.setSchedule()
        }
    }

    func setSchedule()
    {

        var open:String?
        var close:String?
        var startdate:Date?
        var finalDate:Date?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let weekdayFormatter=DateFormatter()
        weekdayFormatter.dateFormat="EEEE"
        for openday in self.filteredOpenDays
        {
            let newdate=self.calendar.nextDate(after: self.date, matching: DateComponents(weekday:openday), matchingPolicy: .nextTime)
            let dayInWeek=weekdayFormatter.string(from: newdate!)
            self.openDaysFinal.append(dayInWeek)
        }
            
        let qref=ref.child("services").child(businessUid!)
        print("DAYS COUNT")
        print(openDaysFinal.count)
        for day in openDaysFinal
            {
                let lowercasedDay=day.lowercased()
                print("DAY:")
                print(day.lowercased())
                print("~~~~~~~~~")
                //print(ref.child("openhours").child(businessUid!).child(day.lowercased()).description())
                let openref=ref.child("openhours").child(businessUid!).child(lowercasedDay).observeSingleEvent(of: .value, with: { (snapshot) in
                    print("HELLLO")
                    print(snapshot)
                    let value = snapshot.value as? NSDictionary
                    open = value?["open"] as? String ?? ""
                    close = value?["closed"] as? String ?? ""
                    startdate = dateFormatter.date(from: open as! String)
                    finalDate = dateFormatter.date(from: close as! String)
                    print("DATES")
                    print(startdate?.description)
                    print(finalDate?.description)
                    for service in self.servicesData
                    {
                        for dayDate in self.filteredDaysString
                        {
                            print(dayDate)
                            let dref=qref.child(service.nameOfService).child(dayDate)
                            
                            var advanceDate=startdate;
                            while advanceDate != finalDate!
                            {
                                print("INSIDE WHILE BOY")
                                let start = self.calendar.dateComponents([.hour, .minute], from: advanceDate!)
                                let shour = start.hour?.description
                                let sminute = start.minute?.description
                                let now=shour!+":"+sminute!
                                print(now)
                                advanceDate = self.calendar.date(byAdding: .minute, value: Int(service.duration)!, to: advanceDate!)
                                
                                let end = self.calendar.dateComponents([.hour, .minute], from: advanceDate!)
                                let hour = end.hour?.description
                                let minute = end.minute?.description
                                
                                let time = shour!+":"+sminute!+"-"+hour!
                                let finaltime=time+":"+minute!
                                print("INSERTING NODE")
                                print(finaltime)
                                dref.child(finaltime)
                            }
                        }
                    }
                })
                
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
                let dayInWeek=weekdayFormatter.string(from: newdate!)
                let month = String(self.calendar.component(.month, from: newdate!))
                let day = String(self.calendar.component(.day, from: newdate!))
                let finalDate=dayInWeek+" "+day+"/"+month
                week1.append(finalDate)

            }
            for openday in self.filteredOpenDays
            {
                print(openday)
                let newdate=self.calendar.nextDate(after: nextWeek!, matching: DateComponents(weekday:openday), matchingPolicy: .nextTime)
                
                let dayInWeek=weekdayFormatter.string(from: newdate!)
                let month = String(self.calendar.component(.month, from: newdate!))
                let day = String(self.calendar.component(.day, from: newdate!))
                let finalDate=dayInWeek+" "+day+"/"+month
                week2.append(finalDate)
            }
            self.filteredDaysString.append(contentsOf: week1)
            self.filteredDaysString.append(contentsOf: week2)
            self.loadTable()
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==dateTimePicker
        {return filteredDaysString.count}
        else {return availableHours.count}
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==dateTimePicker{
        selectDateBtn.setTitle(filteredDaysString[row], for:.normal)
        //category=pickerData[row]
        return filteredDaysString[row]
        }
        else{
            selectTimeBtn.setTitle(availableHours[row], for: .normal)
            return availableHours[row]
        }
    }

    
    
    @IBAction func datePressed(_ sender: Any) {
        if dateTimePicker.isHidden==false
        {
            dateTimePicker.isHidden=true
            selectTimeBtn.isHidden=false
            
        }
        else
        {
            dateTimePicker.isHidden=false
            selectTimeBtn.isHidden=true
        }
        
        
        dateTimePicker.reloadAllComponents();
        
    }
    
    @IBAction func timePressed(_ sender: Any) {
        if timePicker.isHidden==false{
            timePicker.isHidden=true
        }
        else {timePicker.isHidden=false}
        timePicker.reloadAllComponents()
        
    }
    
    
}
