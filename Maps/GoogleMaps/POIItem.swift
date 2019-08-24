//
//  POIItem.swift
//  Maps
//
//  Created by Sebastian Osiński on 24/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import GoogleMaps

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.long)
    }
    
    var title: String? {
        return poi.name
    }
    
    var image: UIImage {
        return UIImage.emoji(poi.emoji)
    }
    
    private let poi: POI
    
    init(poi: POI) {
        self.poi = poi
    }
}
