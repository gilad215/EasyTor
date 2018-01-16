
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
    
    //client
    @IBOutlet weak var clientView: UIView!
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientPhone: UITextField!
    @IBOutlet weak var clientCity: UITextField!
    @IBOutlet weak var clientAddress: UITextField!
    @IBOutlet weak var clientMAil: UITextField!
    @IBOutlet weak var clientPwd: UITextField!
    
    @IBOutlet weak var createBtn: UIButton!
    
    //validation


    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryBtn.layer.cornerRadius = 10
        self.categoryBtn.clipsToBounds = true
        self.createBtn.layer.cornerRadius = 10
        self.createBtn.clipsToBounds = true
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
        if seg.selectedSegmentIndex == 0
        {
            if (self.fullName.text?.isEmpty)!
        {
            let error="Please enter a Business Name"
            self.showMessagePrompt(str: error)
            return
            }
            if (self.phoneTxt.text?.isEmpty)!
            {
                let error="Please enter a Phone Number"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.address.text?.isEmpty)!
            {
                let error="Please enter an Address"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.city.text?.isEmpty)!
            {
                let error="Please enter a City"
                self.showMessagePrompt(str: error)
                return
            }

            if (self.emailTxt.text?.isEmpty)!
            {
                let error="Please enter an Email"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.pwdTxt.text?.isEmpty)!
            {
                let error="Please enter a Password"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.category=="Category")
            {
                let error="Please select a Category"
                self.showMessagePrompt(str: error)
                return
            }
        Auth.auth().createUser(withEmail: emailTxt.text!, password: pwdTxt.text!) { (user, error) in
            
            if let error = error {
                self.showMessagePrompt(str: error.localizedDescription)
                return
            }
            self.ref.child("users").child("business").child((user?.uid)!).setValue(["businessName":self.fullName.text,"phone":self.phoneTxt.text,"address":self.address.text,"city":self.city.text,"category":self.category])
            print("Created Business!")
            self.performSegue(withIdentifier: "createBusiness", sender: self)
            
            
        }
        }
        else {
            if (self.clientName.text?.isEmpty)!
            {
                let error="Please enter a Business Name"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.clientPhone.text?.isEmpty)!
            {
                let error="Please enter a Phone Number"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.clientAddress.text?.isEmpty)!
            {
                let error="Please enter an Address"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.clientCity.text?.isEmpty)!
            {
                let error="Please enter a City"
                self.showMessagePrompt(str: error)
                return
            }
            
            if (self.clientMAil.text?.isEmpty)!
            {
                let error="Please enter an Email"
                self.showMessagePrompt(str: error)
                return
            }
            if (self.clientPwd.text?.isEmpty)!
            {
                let error="Please enter a Password"
                self.showMessagePrompt(str: error)
                return
            }
            Auth.auth().createUser(withEmail: clientMAil.text!, password: clientPwd.text!) { (user, error) in
                if let error = error {
                    self.showMessagePrompt(str: error.localizedDescription)
                    return
                }
                self.ref.child("users").child("clients").child((user?.uid)!).setValue(["name":self.clientName.text,"phone":self.clientPhone.text,"address":self.clientAddress.text,"city":self.clientCity.text])
                print("Created Client!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabVC = storyboard.instantiateViewController(withIdentifier: "ClientTabVC") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController=tabVC
        }
        }
    }
    @IBAction func valuechanged(_ sender: Any) {
        if seg.selectedSegmentIndex == 0
        {
            clientView.isHidden=true
            businessView.isHidden=false
        }
        else { businessView.isHidden=true
            clientView.isHidden=false
            picker.isHidden=true
        }
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
