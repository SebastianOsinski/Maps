//
//  MapKitViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let tileOverlay = TileOverlay()
        tileOverlay.canReplaceMapContent = true

        mapView.addOverlay(tileOverlay)
    }
    
    @IBAction func myLocationButtonTapped(_ sender: Any) {
        requestLocationIfPossible()
    }
    
    private func requestLocationIfPossible() {
        guard [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) else { return }
        
        locationManager.requestLocation()
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
        
        mapView.setRegion(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)
        ), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationIfPossible()
    }
}
