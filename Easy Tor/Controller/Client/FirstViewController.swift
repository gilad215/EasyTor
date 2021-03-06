

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SQLite

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}
class FirstViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource,MyCustomCellDelegator {
    
    var database:Connection!
    let eventsTable = Table("events")
    let e_id = Expression<String>("id")
    let e_bname = Expression<String>("bname")
    let e_bid = Expression<String>("bid")
    let e_cname = Expression<String>("cname")
    let e_cid = Expression<String>("cid")
    let e_service = Expression<String>("service")
    let e_date = Expression<String>("date")
    let e_time = Expression<String>("time")
    let e_bphone = Expression<String>("bphone")
    let e_cphone = Expression<String>("cphone")
    let e_address = Expression<String>("address")

    

    var ref: DatabaseReference! = nil
    var storageRef: StorageReference!=nil
    
    var local_events=[Event]()
    var firebase_events=[Event]()
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
        imagePicker.delegate = self


        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.borderWidth = 2

        do
        {
            let documentDirectory=try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl=documentDirectory.appendingPathComponent("events").appendingPathExtension("sqlite3")
            let database=try Connection(fileUrl.path)
            self.database=database
        }
        catch
        {
            print(error)
        }
        createTable()
        getLocalEvents()
        downloadPic()
        startObserving()
        

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return local_events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as? ClientEventTableCell else {return UITableViewCell()}
        cell.businessName.text=local_events[indexPath.row].bname
        cell.businessAddress.text=local_events[indexPath.row].baddress
        cell.dateLbl.text=local_events[indexPath.row].date
        cell.serviceName.text=local_events[indexPath.row].service
        cell.timeLbl.text=local_events[indexPath.row].time
        cell.businessid=local_events[indexPath.row].bid
        cell.eventKey=local_events[indexPath.row].key
        cell.deleteBtn.layer.cornerRadius = 10
        cell.deleteBtn.clipsToBounds = true
        cell.chatBtn.layer.cornerRadius = 10
        cell.chatBtn.clipsToBounds = true
        cell.serviceName.layer.cornerRadius = 10
        cell.serviceName.clipsToBounds = true
        cell.custom_delegate = self
        cell.delegate=self
        return cell

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func startObserving(){
        ref.child("events").queryOrdered(byChild: "cid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(DataEventType.value) { (snapshot) in
            self.firebase_events.removeAll()

            if self.local_events.isEmpty
            {
            for event in snapshot.children
            {
                print("LOCAL EMPTY")
                let eventObject=Event(snapshot: event as! DataSnapshot)
                self.firebase_events.append(eventObject)
                self.insertLocalEvent(event: eventObject)
            }
                self.getLocalEvents()
            self.tableView.reloadData()

            }
            else
            {
                for event in snapshot.children
                {
                    let eventObject=Event(snapshot: event as! DataSnapshot)
                    self.firebase_events.append(eventObject)
                }
                var eventExistsLocally=false
                for event in self.firebase_events
                {
                    print(event.key)
                    print("~~~~")
                    for localevent in self.local_events
                    {
                        print("COMPARING")
                        print(event.key)
                        print(localevent.key)
                        if localevent.key==event.key {eventExistsLocally=true}
                    }
                    if eventExistsLocally==false {
                        self.insertLocalEvent(event: event)
                    }
                    eventExistsLocally=false
                }
                if self.firebase_events.count>0
                {for localevent in self.local_events
                {
                    print("local:")
                    print(localevent.key)
                    print("FIRE BASE COUNT")
                    print(self.firebase_events.count)
                    
                    print("~~~~~~~~")
                    for event in self.firebase_events
                    {
                        print("CHECKING IF NEED TO DELETE")
                        print(localevent.key)
                        print("~~~~")
                        print("ONLINE EVENT:")
                        print(event.key)
                        if event.key==localevent.key {eventExistsLocally=true;break}
                        
                    }
                    if eventExistsLocally==false
                    {
                        print("FOUND EVENT FOR DELETION")
                        self.deleteLocalEvent(event: localevent)
                    }
                    eventExistsLocally=false
                }
                }
                else
                {
                    for local in self.local_events
                    {
                        self.deleteLocalEvent(event: local)
                    }
                    self.local_events.removeAll()
                }
                
            }
            self.getLocalEvents()
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
        
        let imageData:NSData = UIImagePNGRepresentation(self.image.image!)! as NSData
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        
        picker.dismiss(animated: true, completion: nil)
        
        //uploading to Firebase
        var data=Data()
        data = UIImageJPEGRepresentation(image.image!, 0.8)! as Data
        let filePath = "\((Auth.auth().currentUser?.uid)!)/\("userPhoto")"
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
        if !(UserDefaults.standard.object(forKey: "savedImage")==nil)
        {
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        self.image.image = UIImage(data: data as Data)
        }
        else
        {

            
        ref.child("users").child("clients").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("userPhoto")
            {                
                    //gs://eztor-b332f.appspot.com/EVtvGnZkdzNbKnl7Tlei443CAl33/userPhoto
                let imageURL = Storage.storage().reference(forURL: "gs://eztor-b332f.appspot.com").child((Auth.auth().currentUser?.uid)!).child("userPhoto")
                
                imageURL.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        guard let imageData = UIImage(data: data!) else { return }
                        
                        DispatchQueue.main.async {
                            self.image.image = imageData
                            let imageData:NSData = UIImagePNGRepresentation(self.image.image!)! as NSData
                            UserDefaults.standard.set(imageData, forKey: "savedImage")
                        }
                        
                    }).resume()
                    
                })
                
        }
        })
        }
    }
    
    //profiletoChat
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController

                chatVc.displayName=chat.cname
                chatVc.ID=chat.cid
                chatVc.partner=chat.bname
                chatVc.chatkey=chat.key
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        print("LOGGING OUT")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.removeObject(forKey: "savedImage")
        self.ref.removeAllObservers()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! UIViewController
            self.present(vc, animated: false, completion: nil)
        }
    }

    func createTable()
    {
        let createTable = self.eventsTable.create{(table) in
            table.column(self.e_id,primaryKey:true)
            table.column(self.e_bid)
            table.column(self.e_cid)
            table.column(self.e_date)
            table.column(self.e_time)
            table.column(self.e_service)
            table.column(self.e_address)
            table.column(self.e_cname)
            table.column(self.e_bname)
            table.column(self.e_bphone)
            table.column(self.e_cphone)
        }
            
            do {
                try self.database.run(createTable)
                print("Created Table")
            } catch {
                print(error)
            }
            
    }

    func insertLocalEvent(event:Event)
    {
        let insertevent = self.eventsTable.insert(self.e_id <- event.key, self.e_bid <- event.bid, self.e_cid <- event.cid, self.e_date <- event.date, self.e_time <- event.time, self.e_service <- event.service, self.e_address <- event.baddress, self.e_cname <- event.cname, self.e_bname <- event.bname, self.e_bphone <- event.bphone, self.e_cphone <- event.cphone)
        
        do {
            try self.database.run(insertevent)
            print("INSERTED USER")
        } catch {
            print(error)
        }
    }
    //
    func getLocalEvents()
    {
        self.local_events.removeAll()
        do {
            let events = try self.database.prepare(self.eventsTable)
            for event in events {
                if event[self.e_cid]==Auth.auth().currentUser?.uid
                {
                self.local_events.append(Event(service: event[self.e_service], bid: event[self.e_bid], key:event[self.e_id], cid: event[self.e_cid], time: event[self.e_time], date:event[self.e_date], bname: event[self.e_bname], bphone: event[self.e_bphone], baddress: event[self.e_address], cname: event[self.e_cname], cphone: event[self.e_cphone]))
                }
            }
            //date regex \d\d
            //hour regex
            self.local_events=self.local_events.sorted(by: { (event1, event2) -> Bool in
                let regex="\\d\\d"
                let date1=matches(for:regex, in: event1.date)[0]
                let date2=matches(for:regex, in: event2.date)[0]
                return date1<date2
            })
            self.local_events=self.local_events.sorted(by: { (event1, event2) -> Bool in
                let regex="\\d\\d"
                if event1.date==event2.date
                {
                    let time1=matches(for:regex, in: event1.time)[0]
                    let time2=matches(for:regex, in: event2.time)[0]
                    return time1<time2
                }
                else
                {
                    let date1=matches(for:regex, in: event1.date)[0]
                    let date2=matches(for:regex, in: event2.date)[0]
                    return date1<date2
                }
            })
            for event in self.local_events
            {
                print(event.date)
            }
            print("local events count!!!!!")
            print(self.local_events.count)
        } catch {
            print(error)
        }

    }
    
    func deleteLocalEvent(event:Event)
    {
        let delEvent=self.eventsTable.filter(self.e_id == event.key)
        let delete = delEvent.delete()
        do {
            try self.database.run(delete)
        } catch {
            print(error)
        }
    }
    
    func deleteTable()
    {
        do {
            try self.database.run(eventsTable.delete())
        } catch {
            print(error)
        }
        // DELETE FROM "users"
    }
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }


}
    

    



