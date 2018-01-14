//
//  FirstViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 20/12/2017.
//  Copyright © 2017 Gilad Lekner. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}
class FirstViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource,MyCustomCellDelegator {


    var ref: DatabaseReference! = nil
    var storageRef: StorageReference!=nil
    var events=[Event]()
    var user_name:String!
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var picBtn: UIButton!
    
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        storageRef=Storage.storage().reference()
        super.viewDidLoad()
        downloadPic()
        let clientuid=Auth.auth().currentUser?.uid
        imagePicker.delegate = self

        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        ref.child("users").child(clientuid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let fname = value?["firstName"] as? String ?? ""
            let lname = value?["lastName"] as? String ?? ""
            self.user_name=fname+" "+lname
        })
        startObserving()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as? ClientEventTableCell else {return UITableViewCell()}
        cell.businessName.text=events[indexPath.row].bname
        cell.businessAddress.text=events[indexPath.row].baddress
        cell.dateLbl.text=events[indexPath.row].date
        cell.serviceName.text=events[indexPath.row].service
        cell.timeLbl.text=events[indexPath.row].time
        cell.businessid=events[indexPath.row].bid
        cell.eventKey=events[indexPath.row].key
        cell.deleteBtn.layer.cornerRadius = 10
        cell.deleteBtn.clipsToBounds = true
        cell.chatBtn.layer.cornerRadius = 10
        cell.chatBtn.clipsToBounds = true
        cell.serviceName.layer.cornerRadius = 10
        cell.serviceName.clipsToBounds = true
        cell.delegate = self
        return cell

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func startObserving(){
        ref.child("events").queryOrdered(byChild: "cid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(DataEventType.value) { (snapshot) in
            self.events.removeAll()
            for event in snapshot.children
            {
                let eventObject=Event(snapshot: event as! DataSnapshot)
                self.events.append(eventObject)
            }
            self.tableView.reloadData()

        }
    }
    
    @IBAction func imageClicked(_ sender: Any) {
        print("Image clicked!")
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    
}

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenimage = info[UIImagePickerControllerEditedImage] as! UIImage
        image.image=chosenimage
        // image is our desired image
        
        picker.dismiss(animated: true, completion: nil)
        
        //uploading to Firebase
        var data=Data()
        data = UIImageJPEGRepresentation(image.image!, 0.8)! as Data
        let filePath = "\(Auth.auth().currentUser?.uid)/\("userPhoto")"
        let metaData = StorageMetadata()
        metaData.contentType="image/jpg"
        self.storageRef.child(filePath).putData(data,metadata:metaData){
            (metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                self.ref.child("users").child("clients").child(Auth.auth().currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }
        }
    }
    func callSegueFromCell(myData dataobject: AnyObject) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "profiletoChat", sender:dataobject )
        
    }
        
    func downloadPic()
    {
//        ref.child("users").child("clients").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            // check if user has photo
//            if snapshot.hasChild("userPhoto"){
//                // set image locatin
//                print("found pic!")
//                let filePath = "\(Auth.auth().currentUser!.uid)/\("userPhoto")"
//                // Assuming a < 10MB file, though you can change that
//                self.storageRef.child(filePath).getData(maxSize: 10*1024*1024, completion: { (data, error) in
//                    print(data)
//                    let userPhoto = UIImage(data: data!)
//                    self.image.image = userPhoto
//                })
//            }
//        })
        }
    
    //profiletoChat
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController

                chatVc.displayName=chat.bname
                chatVc.ID=chat.bid
                chatVc.partner=chat.bname
                chatVc.chatkey=chat.key
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        print("LOGGING OUT")
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! UIViewController
            self.present(vc, animated: false, completion: nil)
        }
    }

    
}
    

    



