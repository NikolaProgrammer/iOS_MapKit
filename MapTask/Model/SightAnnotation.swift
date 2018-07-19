//
//  Sight.swift
//  MapKit
//
//  Created by Nikolay Sereda on 18.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation
import MapKit

class SightAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var annotationDescription: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, annotationDescription: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.annotationDescription = annotationDescription
    }
    
}
