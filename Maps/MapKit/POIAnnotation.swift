//
//  POIAnnotation.swift
//  Maps
//
//  Created by Sebastian Osiński on 23/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.long)
    }
    
    var title: String? {
        return poi.name
    }
    
    var glyph: String {
        return poi.emoji
    }
    
    private let poi: POI
    
    init(poi: POI) {
        self.poi = poi
    }
}
