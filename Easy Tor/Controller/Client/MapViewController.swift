//
//  MapViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 11/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference! = nil
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    

    var city : String!
    var address : String!
    var businessArray = [Business]()
    var coordinatesArray = [CLLocationCoordinate2D]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
        
        ref = Database.database().reference()
        let location = CLLocationCoordinate2DMake(31.970169, 34.773900)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 1500, 1500), animated: true)
        let pin = PinAnnotation(title: "MY SCHOOL", subTitle: "COME VISIT!", coordinate: location)
        mapView.addAnnotation(pin)
        
        getCity()

        
    }
    
    
    func getCity(){
        
        print(self.locationManager.location) //ashdod
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.locationManager.location!) { (placemarks, error) in
            
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            
            if let city = addressDict["City"] as? String {
                print(city)
                self.city=city
            }

        }
        
        //        let city = ref.child("users").child("clients").child((Auth.auth().currentUser?.uid)!).observe(DataEventType.value) { (snapshot) in
//
//            let value = snapshot.value as? NSDictionary
//            self.city = value?["city"] as? String ?? ""
//            self.address = value?["address"] as? String ?? ""
            //self.getBusinessInCity()
        //}
    }
    func getBusinessInCity(){
        ref.child("users").child("business").queryOrdered(byChild: "city").queryEqual(toValue: self.city).observe(.value) { (snapshot) in
            print(self.city)
            print(snapshot)
            for business in snapshot.children{
                let businessObj = Business(snapshot: business as! DataSnapshot)
                print("@@@@@@@@@@@@@@")
                
                print(businessObj.address)
                var fullAddress=businessObj.city+" "+businessObj.address
                self.businessArray.append(businessObj)
                self.getCoordinate(addressString: fullAddress, completionHandler: { (coordinate, error) in
                    if error==nil
                    {
                        print("COORDINATE!")
                        print(coordinate)
                        self.coordinatesArray.append(coordinate)
                    }
                    else
                    {
                        print(error)
                    }
                })
                
            }
            //
        }
        
    }
    
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    

    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
