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
    private let poiReuseIdentifier = "poi"
    private let poiClusteringIdentifier = "poiCluster"
    
    private let mapView = MKMapView()
    
    private var tileOverlay: TileOverlay?
    
    private var selectedPOIAnnotation: POIAnnotation? {
        didSet {
            setLeftBarButtons(enabled: selectedPOIAnnotation != nil)
        }
    }
    
    private var currentRouteOverlays: [MKOverlay]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView(mapView)
        
        setMapModeButton(mode: .original)
        setLeftBarButtons(enabled: false)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: poiReuseIdentifier)
        
        loadPOIs()
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
    
    override func navigateButtonTapped() {
        guard let selectedPOIAnnotation = selectedPOIAnnotation else { return }
        
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedPOIAnnotation.coordinate))
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] (response, error) in
            guard error == nil else {
                return log.error(error!)
            }
            
            guard let response = response else {
                return log.info("No route for given request")
            }
            
            self?.showRoutes(response.routes)
        }
    }
    
    override func setLocationOnMap(_ location: CLLocation) {
        mapView.setRegion(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ), animated: true)
    }
    
    override func showPOIs(_ pois: [POI]) {
        mapView.showAnnotations(pois.map(POIAnnotation.init), animated: true)
    }
    
    private func showRoutes(_ routes: [MKRoute]) {
        let polylines = routes.map { $0.polyline }
        
        mapView.addOverlays(polylines)
        currentRouteOverlays = polylines
    }
}

extension MapKitViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let poiAnnotation as POIAnnotation:
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: poiReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            
            view.glyphText = poiAnnotation.glyph
            view.markerTintColor = .systemTeal
            view.displayPriority = .required
            view.clusteringIdentifier = poiClusteringIdentifier
            
            return view
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is TileOverlay:
            return MKTileOverlayRenderer(overlay: overlay)
        case is MKPolyline:
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemGreen
            return renderer
        default: fatalError()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedPOIAnnotation = view.annotation as? POIAnnotation
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedPOIAnnotation = nil
        if let overlays = currentRouteOverlays {
            mapView.removeOverlays(overlays)
        }
    }
}
