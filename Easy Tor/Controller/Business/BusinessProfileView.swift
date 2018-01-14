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

class BusinessProfileView: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource {
    var ref: DatabaseReference! = nil
    var storageRef: StorageReference!=nil
    var events=[Event]()
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var picBtn: UIButton!
    @IBOutlet weak var chkMsgsBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        chkMsgsBtn.layer.cornerRadius = 10
        chkMsgsBtn.clipsToBounds = true
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
        startObserving()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessEventTableCell") as? BusinessEventTableCell else {return UITableViewCell()}
            cell.dateLbl.text=self.events[indexPath.row].date
            cell.serviceName.text=self.events[indexPath.row].service
            cell.timeLbl.text=self.events[indexPath.row].time
            cell.eventKey=self.events[indexPath.row].key
        cell.clientPhone.text=self.events[indexPath.row].cphone
        cell.clientName.text=self.events[indexPath.row].cname
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startObserving(){
        ref.child("events").queryOrdered(byChild: "bid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(DataEventType.value) { (snapshot) in
            print(snapshot)
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
    
    //segue - busMessagesSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messageVC=segue.destination as? MessagesViewController {
            messageVC.isClient=false
        }
    }
    
    
}
    

    



