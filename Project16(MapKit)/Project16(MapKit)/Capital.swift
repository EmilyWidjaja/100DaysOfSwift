//
//  Capital.swift
//  Project16(MapKit)
//
//  Created by Emily Widjaja on 20/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {     //MK Annotation defines place on a map
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }

}
