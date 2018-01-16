//
//  PinAnnotation.swift
//  Easy Tor
//
//  Created by Sharon Gueta on 15/01/2018.
//  Copyright © 2018 Gilad Lekner. All rights reserved.
//
import MapKit

class PinAnnotation : NSObject, MKAnnotation
    
{
    var title: String?
    var subTitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String,subTitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        
    }
    
    
}
