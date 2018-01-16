
import UIKit
import FirebaseDatabase
import FirebaseAuth

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
    var businessName:String?
    var businessPhone:String?
    var businessAddr:String?
    
    var clientUid:String?
    
    var addedbyBusiness=false
    var clientPhone:String?
    var clientName:String?
    var ref: DatabaseReference! = nil
    var servicesData: [Service] = [Service]()
    var openDays=["sunday","monday","tuesday","wednesday","thursday","friday","saturday"]
    var filteredOpenDays:[Int] = [Int]()
    var filteredDaysString:[String] = [String]()
    var openDaysFinal:[String] = [String]()
    
    var availableHours:[String] = [String]()
    
    var selectedService:String?=nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.selectDateBtn.layer.cornerRadius = 10
        self.selectDateBtn.clipsToBounds = true
        self.selectTimeBtn.layer.cornerRadius = 10
        self.selectTimeBtn.clipsToBounds = true
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
                            if (dayDate.range(of: day) != nil)
                            {
                                self.ref.child("availablehours").child(self.businessUid!).child("services").child(service.nameOfService).observeSingleEvent(of: .value, with: { (snapshot) in
                                    if !(snapshot.hasChild(dayDate))
                                    {
                                
                                        print(dayDate)
                                        
                                        var advanceDate=startdate;
                                        while advanceDate != finalDate!
                                        {
                                            print("INSIDE WHILE BOY")
                                            let start = self.calendar.dateComponents([.hour, .minute], from: advanceDate!)
                                            let shour = start.hour?.description
                                            let sminute = start.minute
                                            var sminutestring:String?
                                            if sminute!<10
                                            {
                                                sminutestring="0"+(sminute?.description)!
                                            }
                                            else {sminutestring=sminute?.description}
                                            
                                            let now=shour!+":"+sminutestring!
                                            print(now)
                                            advanceDate = self.calendar.date(byAdding: .minute, value: Int(service.duration)!, to: advanceDate!)
                                            
                                            let end = self.calendar.dateComponents([.hour, .minute], from: advanceDate!)
                                            let hour = end.hour?.description
                                            let minute = end.minute
                                            var minutestring:String?
                                            if minute!<10
                                            {
                                                minutestring="0"+(minute?.description)!
                                            }
                                            else {minutestring=minute?.description}
                                            
                                            let time = shour!+":"+sminutestring!+"-"+hour!
                                            let finaltime=time+":"+minutestring!
                                            print("INSERTING NODE")
                                            print(finaltime)
                                            print(dayDate)
                                        self.ref.child("availablehours").child(self.businessUid!).child("services").child(service.nameOfService).child(dayDate).child(finaltime).setValue(["time":finaltime])
                                        }
                                        
                                    }
                            })
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
                let finalDate=dayInWeek+" "+day+"-"+month
                week1.append(finalDate)

            }
            for openday in self.filteredOpenDays
            {
                print(openday)
                let newdate=self.calendar.nextDate(after: nextWeek!, matching: DateComponents(weekday:openday), matchingPolicy: .nextTime)
                
                let dayInWeek=weekdayFormatter.string(from: newdate!)
                let month = String(self.calendar.component(.month, from: newdate!))
                let day = String(self.calendar.component(.day, from: newdate!))
                let finalDate=dayInWeek+" "+day+"-"+month
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
        {
            return filteredDaysString.count
            
        }
        if pickerView==timePicker
        {
            return availableHours.count
            
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==dateTimePicker{
        selectDateBtn.setTitle(filteredDaysString[row], for:.normal)
        //category=pickerData[row]
        return filteredDaysString[row]
        }
        if pickerView==timePicker{
            selectTimeBtn.setTitle(availableHours[row], for: .normal)
            return availableHours[row]
        }
        return nil
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
        }
        
        
        dateTimePicker.reloadAllComponents();
        
    }
    
    @IBAction func timePressed(_ sender: Any) {
        if selectedService==nil
        {
            self.showMessagePrompt(str: "Please select a service")
            return
        }
        if timePicker.isHidden==false{
            timePicker.isHidden=true
        }
        else {timePicker.isHidden=false}
        
        let houRef=ref.child("availablehours").child(businessUid!).child("services").child(selectedService!).child((selectDateBtn.titleLabel?.text)!).observe(.value) { (snapshot) in
            self.availableHours.removeAll()
            for time in snapshot.children
            {
                
                let valuer = time as! DataSnapshot
                let dictionary=valuer.value as? NSDictionary
                let timer = dictionary?["time"] as? String ?? ""
                self.availableHours.append(timer)
                
            }
            print("~~~~~~~~~")
            print(self.availableHours.count)
            self.timePicker.reloadAllComponents()
        }
        self.timePicker.reloadAllComponents()
        
    }
    
    @IBAction func pressedFinish(_ sender: Any)
    {
        if selectTimeBtn.titleLabel?.text=="Time"
        {
            self.showMessagePrompt(str: "Please select a valid Date and Time")
            return
        }
            let bref=ref.child("users").child("business").child(businessUid!).observeSingleEvent(of: .value, with: { (snapshot2) in
                print(snapshot2)
                let value = snapshot2.value as? NSDictionary
                    self.businessName = value?["businessName"] as? String ?? ""
                    self.businessPhone = value?["phone"] as? String ?? ""
                    self.businessAddr = value?["address"] as? String ?? ""
                    print("got name!!!!!")
                    print(self.businessName)
                
                let cref=self.ref.child("users").child("clients").child(self.clientUid!).observeSingleEvent(of: DataEventType.value, with: { (snapshot3) in
                    let cvalue = snapshot3.value as? NSDictionary
                    self.clientName = cvalue?["name"] as? String ?? ""
                    self.clientPhone = cvalue?["phone"] as? String ?? ""
                
                    let eref=self.ref.child("events").childByAutoId()
                    eref.setValue(["service":self.selectedService,"date":self.selectDateBtn.titleLabel?.text,"time":self.selectTimeBtn.titleLabel?.text,"bid":self.businessUid!,"cid":self.clientUid,"businessName":self.businessName,"address":self.businessAddr,"businessPhone":self.businessPhone,"clientName":self.clientName,"clientPhone":self.clientPhone])
                })
            })

        self.ref.child("availablehours").child(self.businessUid!).child("services").child(selectedService!).child((selectDateBtn.titleLabel?.text)!).child((selectTimeBtn.titleLabel?.text)!).removeValue { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                print("Child Removed Correctly")
        }
        
        }
        if !(addedbyBusiness)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = storyboard.instantiateViewController(withIdentifier: "ClientTabVC") as! UIViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController=tabVC
        }
        else
        {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "businessTabVC") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController=tabVC
        }
    }
    func showMessagePrompt(str:String)
    {
        print("showing message")
        // create the alert
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    
}
