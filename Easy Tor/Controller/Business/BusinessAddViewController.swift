
import UIKit
import FirebaseAuth
import FirebaseDatabase
class BusinessAddViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var clients: [Client]=[Client]()
    var ref: DatabaseReference! = nil
    var selectedClient:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getClients()
        // Do any additional setup after loading the view.
    }

  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "ClientCell") as? TableCell else {return UITableViewCell()}
        cell.nameLbl.text=clients[indexPath.row].name
        cell.categoryLbl.text=clients[indexPath.row].phone
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("KEY CLIENT ISSSSSS!!!")
        print(clients[indexPath.row].key)
        self.selectedClient=clients[indexPath.row].key
        self.performSegue(withIdentifier: "eventByBusiness", sender: selectedClient)
    }
    
    func getClients()
    {
        let cref=ref.child("events").queryOrdered(byChild: "bid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(DataEventType.value) { (snapshot) in
            print(snapshot)
            self.clients.removeAll()
            for client in snapshot.children
            {
                let valuer = client as! DataSnapshot
                let dictionary=valuer.value as? NSDictionary
                
                let name = dictionary?["clientName"] as? String ?? ""
                let phone = dictionary?["clientPhone"] as? String ?? ""
                let cid = dictionary?["cid"] as? String ?? ""
                
                if !(self.clients.contains(where: { (client) -> Bool in
                    client.key==cid
                }))
                {
                    self.clients.append(Client(name:name,key:cid, phone:phone))
                }

            }
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chooseServiceVC=segue.destination as? ChooseServicesViewController {
            print("SELECTED CLIENT")
            print(selectedClient)
            chooseServiceVC.businessUid=Auth.auth().currentUser?.uid
            chooseServiceVC.clientUid=selectedClient
            chooseServiceVC.addedbyBusiness=true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
