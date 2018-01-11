//
//  MapViewController.swift
//  Easy Tor
//
//  Created by Gilad Lekner on 11/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let span:MKCoordinateSpan=MKCoordinateSpanMake(0.1, 0.1)
    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(31.970169, 34.773900)
    var region:MKCoordinateRegion!
    var annotation:MKPointAnnotation!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        region=MKCoordinateRegionMake(self.location, self.span)
        mapView.setRegion(region, animated: true)
        annotation=MKPointAnnotation()
        annotation.title="My School!"
        annotation.subtitle="Come visit!"
        mapView.addAnnotation(annotation)

        // Do any additional setup after loading the view.
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
