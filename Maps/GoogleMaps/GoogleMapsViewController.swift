//
//  GoogleMapsViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: BaseMapViewController {
    private let mapView = DarkModeGMSMapView()
    private let tileLayer = TileLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView(mapView)
        
        setMapModeButton(mode: .original)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
    }
    
    override func currentLocationButtonTapped() {
        guard let location = mapView.myLocation else {
            return requestLocationIfPossible()
        }
        
        setLocationOnMap(location)
    }
    
    override func switchMapModeButtonTapped() {
        if mapView.mapType == .none {
            mapView.mapType = .normal
            tileLayer.map = nil
            
            setMapModeButton(mode: .original)
        } else {
            mapView.mapType = .none
            tileLayer.map = mapView
            
            setMapModeButton(mode: .custom)
        }
    }
    
    override func setLocationOnMap(_ location: CLLocation) {
        mapView.animate(toLocation: location.coordinate)
        mapView.animate(toZoom: 16)
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {
    
}
