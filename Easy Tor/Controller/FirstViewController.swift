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

class FirstViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var ref: DatabaseReference! = nil
    var storageRef: StorageReference!=nil
    var events=[Event]()
    var user_name:String!
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var event3: UILabel!
    @IBOutlet weak var picBtn: UIButton!
    
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        storageRef=Storage.storage().reference()
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func addEvent(_ sender: Any) {
        let eventAlert = UIAlertController(title: "Add Event", message: "Enter your event", preferredStyle: .alert)
        eventAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder="Your event"
        }
        
        eventAlert.addAction(UIAlertAction(title:"Send",style:.default,handler:{(action:UIAlertAction) in
            if let eventContent=eventAlert.textFields?.first?.text{
                let event=Event(content: eventContent, addedByUser: self.user_name)
            
            let eventRef=self.ref.child("events").child(eventContent.lowercased())
                eventRef.setValue(event.toAnyObject())
            }
            
        }))
        self.present(eventAlert,animated: true,completion: nil)
    }
    
    func startObserving(){
        ref.child("events").observe(DataEventType.value) { (snapshot) in
            var newEvents=[Event]()
            for event in snapshot.children
            {
                let eventObject=Event(snapshot: event as! DataSnapshot)
                newEvents.append(eventObject)
            }
            
            self.events=newEvents
            print("events size:",self.events.count);
            //self.event1.text=self.events[0].content+" "+self.events[0].date
            //self.event2.text=self.events[1].content+" "+self.events[1].date
            //self.event3.text=self.events[2].content+" "+self.events[2].date

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
                self.ref.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }
        }
        
       
        

    }
}
    

    



