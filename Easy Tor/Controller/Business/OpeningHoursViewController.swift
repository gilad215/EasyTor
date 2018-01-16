
import UIKit
import FirebaseDatabase
import FirebaseAuth

class OpeningHoursViewController: UIViewController {

    var ref: DatabaseReference! = nil
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
    
    @IBOutlet weak var sunday_switch: UISwitch!
    
    @IBOutlet weak var monday_switch: UISwitch!
    
    @IBOutlet weak var tuesday_switch: UISwitch!
    
    @IBOutlet weak var wednesday_switch: UISwitch!
    
    @IBOutlet weak var thursday_switch: UISwitch!
    
    @IBOutlet weak var friday_switch: UISwitch!
    
    @IBOutlet weak var saturday_switch: UISwitch!
    
    @IBAction func daySwitched(_ sender: UISwitch) {
        if sender.isOn
        {
            switch (sender.tag)
            {
            case (1):
                
                sunday_open.isHidden=false
                sunday_closed.isHidden=false
            
            case (2):
                monday_closed.isHidden=false
                monday_open.isHidden=false
                
            case (3):
                tuesday_open.isHidden=false
                tuesday_closed.isHidden=false
                
            case (4):
                wednesday_open.isHidden=false
                wednesday_closed.isHidden=false
            
            case(5):
                thursday_open.isHidden=false
                thursday_closed.isHidden=false
                
            case(6):
                friday_open.isHidden=false
                friday_closed.isHidden=false
            case(7):
                saturday_open.isHidden=false
                saturday_closed.isHidden=false
            default:
                print("hi")
            }
        
        }
        else
        {
            switch (sender.tag)
            {
            case (1):
                
                sunday_open.isHidden=true
                sunday_closed.isHidden=true
                
            case (2):
                monday_closed.isHidden=true
                monday_open.isHidden=true
                
            case (3):
                tuesday_open.isHidden=true
                tuesday_closed.isHidden=true
                
            case (4):
                wednesday_open.isHidden=true
                wednesday_closed.isHidden=true
                
                
            case (5):
                thursday_open.isHidden=true
                thursday_closed.isHidden=true
                
            case (6):
                friday_open.isHidden=true
                friday_closed.isHidden=true
            case (7):
                saturday_open.isHidden=true
                saturday_closed.isHidden=true
            default:
                print("hi")
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
        timePicker.datePickerMode = .time
        timePicker.minuteInterval=30
        designButtons()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressedTime(_ sender: UIButton) {
        if timePicker.isHidden==true { timePicker.isHidden=false}
        else if timePicker.isHidden==false { timePicker.isHidden=true}
        var timedate:String!
        var minute:String!
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour=components.hour!
        if components.minute!<10
        {
            minute="0"+(components.minute?.description)!
        }
        else{
            minute=components.minute!.description
        }
        timedate=hour.description+":"+minute
        sender.setTitle(timedate, for: .normal)

        
    }
    
    
    @IBAction func pressedFinish(_ sender: Any) {
        
        if sunday_switch.isOn==false && monday_switch.isOn==false && tuesday_switch.isOn==false && wednesday_switch.isOn==false
        && thursday_switch.isOn==false && friday_switch.isOn==false && saturday_switch.isOn==false
        {
            self.showMessagePrompt(str: "Please select at least one Day")
            return
        }
        
        //to put dates inside the business node
        let currentuser=Auth.auth().currentUser
        let dateRef=ref.child("openhours").child((currentuser?.uid)!)
        
        if sunday_switch.isOn
        {
            if sunday_open.titleLabel?.text=="Open" || sunday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("sunday").setValue(["open":sunday_open.title(for:.normal),"closed":sunday_closed.title(for: .normal)])
        }
        if monday_switch.isOn
        {
            if monday_open.titleLabel?.text=="Open" || monday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("monday").setValue(["open":monday_open.title(for:.normal),"closed":monday_closed.title(for: .normal)])

        }
        if tuesday_switch.isOn
        {
            if tuesday_open.titleLabel?.text=="Open" || tuesday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("tuesday").setValue(["open":tuesday_open.title(for:.normal),"closed":tuesday_closed.title(for: .normal)])

        }
        if wednesday_switch.isOn
        {
            if wednesday_open.titleLabel?.text=="Open" || wednesday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("wednesday").setValue(["open":wednesday_open.title(for:.normal),"closed":wednesday_closed.title(for: .normal)])

        }
        if thursday_switch.isOn
        {
            if thursday_open.titleLabel?.text=="Open" || thursday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("thursday").setValue(["open":thursday_open.title(for:.normal),"closed":thursday_closed.title(for: .normal)])

        }
        if friday_switch.isOn
        {
            if friday_open.titleLabel?.text=="Open" || friday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("friday").setValue(["open":friday_open.title(for:.normal),"closed":friday_closed.title(for: .normal)])

        }
        if saturday_switch.isOn
        {
            if saturday_open.titleLabel?.text=="Open" || saturday_closed.titleLabel?.text=="Closed"
            {
                self.showMessagePrompt(str: "Please select valid open hours")
                return
            }
            dateRef.child("saturday").setValue(["open":saturday_open.title(for:.normal),"closed":saturday_closed.title(for: .normal)])

        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "businessTabVC") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController=tabVC
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

    func designButtons()
    {
        self.sunday_open.layer.cornerRadius = 10
        self.sunday_open.clipsToBounds = true
        self.sunday_closed.layer.cornerRadius = 10
        self.sunday_closed.clipsToBounds = true
        
        self.monday_open.layer.cornerRadius = 10
        self.monday_open.clipsToBounds = true
        self.monday_closed.layer.cornerRadius = 10
        self.monday_closed.clipsToBounds = true
    
        self.tuesday_open.layer.cornerRadius = 10
        self.tuesday_open.clipsToBounds = true
        self.tuesday_closed.layer.cornerRadius = 10
        self.tuesday_closed.clipsToBounds = true
        
        self.wednesday_open.layer.cornerRadius = 10
        self.wednesday_open.clipsToBounds = true
        self.wednesday_closed.layer.cornerRadius = 10
        self.wednesday_closed.clipsToBounds = true
        
        self.thursday_open.layer.cornerRadius = 10
        self.thursday_open.clipsToBounds = true
        self.thursday_closed.layer.cornerRadius = 10
        self.thursday_closed.clipsToBounds = true
        
        self.friday_open.layer.cornerRadius = 10
        self.friday_open.clipsToBounds = true
        self.friday_closed.layer.cornerRadius = 10
        self.friday_closed.clipsToBounds = true
        
        self.saturday_open.layer.cornerRadius = 10
        self.saturday_open.clipsToBounds = true
        self.saturday_closed.layer.cornerRadius = 10
        self.saturday_closed.clipsToBounds = true

        
    }
}
