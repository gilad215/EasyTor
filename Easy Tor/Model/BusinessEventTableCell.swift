
import Foundation
import FirebaseAuth
import FirebaseDatabase

class BusinessEventTableCell: UITableViewCell {
    
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    var delegate: UIViewController?
    @IBOutlet weak var deleteBtn: UIButton!

    
    
    var ref: DatabaseReference! = nil
    
    
    var eventKey:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deletePressed(_ sender: Any)
    {
        showMessagePrompt(str: "")
    }
    func showMessagePrompt(str:String)
    {
        print("showing message")
        // create the alert
        let alert = UIAlertController(title: "Are you sure you want to delete this Event?", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let currentUser=Auth.auth().currentUser?.uid
            self.ref = Database.database().reference()
            print("DELETE PRESSED")
            self.ref.child("events").child(self.eventKey!).removeValue { (error, refer) in
                if error != nil {
                    print(error)
                } else {
                    print(refer)
                    print("Child Removed Correctly")
                    self.ref.child("availablehours").child(currentUser!).child("services").child(self.serviceName.text!).child(self.dateLbl.text!).child(self.timeLbl.text!).updateChildValues(["time":self.timeLbl.text!])
                }
            }

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            return
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.delegate?.present(alert, animated: true, completion: nil)
    }
}
