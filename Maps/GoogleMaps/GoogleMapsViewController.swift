//
//  GoogleMapsViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        mapView.mapType = .none
        let tileLayer = TileLayer()
        tileLayer.map = mapView
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {
    
}

