//
//  SearchViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 02/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var ref: DatabaseReference! = nil

    var data = [Business]()
    var filterBusinesses = [Business]()
    var selectedBusiness:String!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        ref = Database.database().reference()
        getBusiness()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{return UITableViewCell()}
        
        cell.nameLbl.text=filterBusinesses[indexPath.row].name
        cell.addressLbl.text=filterBusinesses[indexPath.row].address
        cell.categoryLbl.text=filterBusinesses[indexPath.row].category
        cell.key=filterBusinesses[indexPath.row].key
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! TableCell
        selectedBusiness=currentCell.key
        self.performSegue(withIdentifier: "searchToService", sender: nil)
    }
    
    func searchBar(_ searchBar:UISearchBar,textDidChange searchText:String)
    {
        filterBusinesses = data.filter({ (text) -> Bool in
            
            let name: NSString = text.name! as NSString
            let range = name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
            
        })
        
        self.tableView.reloadData()
        }
    
    
    func getBusiness()
    {
        let bref=ref.child("users").child("business").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for business in snapshot.children
            {
                let businessObject=Business(snapshot:business as! DataSnapshot)
                self.data.append(businessObject)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chooseServiceVC=segue.destination as? ChooseServicesViewController {
            chooseServiceVC.businessUid=selectedBusiness
            chooseServiceVC.clientUid=Auth.auth().currentUser?.uid
        }
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
