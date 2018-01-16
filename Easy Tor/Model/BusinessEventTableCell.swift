
import Foundation
import FirebaseAuth
import FirebaseDatabase

class BusinessEventTableCell: UITableViewCell {
    
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
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
        let currentUser=Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        print("DELETE PRESSED"); self.ref.child("events").child(eventKey!).removeValue { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                print("Child Removed Correctly")
                self.ref.child("availablehours").child(currentUser!).child("services").child(self.serviceName.text!).child(self.dateLbl.text!).child(self.timeLbl.text!).updateChildValues(["time":self.timeLbl.text!])
            }
        }
}
}
