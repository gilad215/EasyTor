//
//  SearchViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 02/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var ref: DatabaseReference! = nil

    var data = [Business]()
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{return UITableViewCell()}
        
        cell.nameLbl.text=data[indexPath.row].name
        cell.addressLbl.text=data[indexPath.row].address
        cell.categoryLbl.text=data[indexPath.row].category
        return cell

    }
    
    func searchBar(_ searchBar:UISearchBar,textDidChange searchText:String)
    {
        print("Searching for:"+searchText)
        let qref=ref.child("users").child("business")
        qref.queryOrdered(byChild: "businessName").queryStarting(atValue: searchText).observe(DataEventType.value) { (snapshot) in
            self.data.removeAll()
            self.tableView.reloadData()
            for business in snapshot.children
            {
                print(snapshot.value)
                let businessObject=Business(snapshot:business as! DataSnapshot)
                self.data.append(businessObject)
            }
            print(self.data.count)
            self.tableView.reloadData()
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
