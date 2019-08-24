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
    
    private var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView(mapView)
        
        setMapModeButton(mode: .original)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(
            map: mapView,
            algorithm: GMUNonHierarchicalDistanceBasedAlgorithm(),
            renderer: renderer
        )
        
        loadPOIs()
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
    
    override func showPOIs(_ pois: [POI]) {
        clusterManager.add(pois.map(POIItem.init))
        clusterManager.cluster()
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {}

extension GoogleMapsViewController: GMUClusterRendererDelegate {
    // Looks like this method is only customization point where we can set our own images and titles for item markers as we do not create markers ourselves anymore.
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        // Check if marker is item marker, not cluster item.
        // Cluster items have userData of type GMUCluster
        guard let poiItem = marker.userData as? POIItem else { return }
        
        marker.icon = poiItem.image
        marker.title = poiItem.title
    }
}
