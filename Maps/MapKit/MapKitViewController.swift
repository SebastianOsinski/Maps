//
//  MapKitViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: BaseMapViewController<MKMapView> {
    private let locationManager = CLLocationManager()
    
    private var tileOverlay: TileOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapModeButton(mode: .original)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
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
    
    private func requestLocationIfPossible() {
        guard [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) else { return }
        
        locationManager.requestLocation()
    }
    
    private func setLocationOnMap(_ location: CLLocation) {
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

extension MapKitViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        setLocationOnMap(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationIfPossible()
    }
}
