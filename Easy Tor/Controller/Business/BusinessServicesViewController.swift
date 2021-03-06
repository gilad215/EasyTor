
import UIKit
import FirebaseDatabase
import FirebaseAuth

class BusinessServicesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var servicesData: [Service] = [Service]()
    var ref: DatabaseReference! = nil

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = 10
        addBtn.clipsToBounds = true
        ref = Database.database().reference()
        getServices()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? ServiceTableCell else {return UITableViewCell()}
        cell.serviceLbl.text=servicesData[indexPath.row].nameOfService
        cell.durationLbl.text=servicesData[indexPath.row].duration
        cell.service=servicesData[indexPath.row]
        
        return cell
    }

    //businessAddService
    @IBAction func addPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "businessAddService", sender: nil)
    }
    
    func getServices()
    {
        ref.child("services").child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
            self.servicesData.removeAll()
            for service in snapshot.children
            {
                let serviceObject=Service(snapshot: service as! DataSnapshot)
                self.servicesData.append(serviceObject)
            }
            self.tableView.reloadData()
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chooseServiceVC=segue.destination as? businessRegViewController {
            chooseServiceVC.businessLoggedIn=true
        }
    }

}
