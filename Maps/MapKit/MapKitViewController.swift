//
//  MapKitViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: BaseMapViewController {
    private let mapView = MKMapView()
    
    private var tileOverlay: TileOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView(mapView)
        
        setMapModeButton(mode: .original)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    override func currentLocationButtonTapped() {
        guard let location = mapView.userLocation.location else {
            return requestLocationIfPossible()
        }
        
        setLocationOnMap(location)
    }
    
    override func switchMapModeButtonTapped() {
        if let tileOverlay = tileOverlay {
            mapView.removeOverlay(tileOverlay)
            self.tileOverlay = nil
            setMapModeButton(mode: .original)
        } else {
            tileOverlay = TileOverlay()
            tileOverlay!.canReplaceMapContent = true
            mapView.addOverlay(tileOverlay!)
            setMapModeButton(mode: .custom)
        }
    }
    
    override func setLocationOnMap(_ location: CLLocation) {
        mapView.setRegion(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ), animated: true)
    }
}

extension MapKitViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is TileOverlay: return MKTileOverlayRenderer(overlay: overlay)
        default: fatalError()
        }
    }
}
