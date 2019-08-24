//
//  BaseMapViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 23/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit
import CoreLocation

class BaseMapViewController: UIViewController {
    enum MapMode {
        case original
        case custom
        
        fileprivate var buttonImage: UIImage? {
            switch self {
            case .original: return UIImage(systemName: "map")
            case .custom: return UIImage(systemName: "map.fill")
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    private let poiProvider = POIProvider()
    private let switchMapModeButton = UIBarButtonItem()
    private let navigateButton = UIBarButtonItem(image: UIImage(systemName: "arrow.turn.right.up"), style: .plain, target: nil, action: nil)
    private let toggleShapeButton = UIBarButtonItem(image: UIImage(systemName: "skew"), style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        locationManager.delegate = self
    }
    
    private func setupNavigationBar() {
        switchMapModeButton.target = self
        switchMapModeButton.action = #selector(switchMapModeButtonTapped)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(currentLocationButtonTapped)),
            switchMapModeButton
        ]
        
        navigateButton.target = self
        navigateButton.action = #selector(navigateButtonTapped)
        
        toggleShapeButton.target = self
        toggleShapeButton.action = #selector(toggleShapeButtonTapped)
        
        navigationItem.leftBarButtonItems = [
            navigateButton,
            toggleShapeButton
        ]
    }
    
    func setupMapView(_ mapView: UIView) {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setMapModeButton(mode: MapMode) {
        switchMapModeButton.image = mode.buttonImage
    }
    
    func setLeftBarButtons(enabled: Bool) {
        navigateButton.isEnabled = enabled
        toggleShapeButton.isEnabled = enabled
    }
    
    func requestLocationIfPossible() {
        guard [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) else {
            locationManager.requestWhenInUseAuthorization()
            
            return
        }
        
        locationManager.requestLocation()
    }
    
    func loadPOIs() {
        poiProvider.loadPOIs { [weak self] pois in
            if let pois = pois {
                self?.showPOIs(pois)
            }
        }
    }
    
    func setLocationOnMap(_ location: CLLocation) {}
    
    func showPOIs(_ pois: [POI]) {}
    
    @objc func currentLocationButtonTapped() {}
    
    @objc func switchMapModeButtonTapped() {}
    
    @objc func navigateButtonTapped() {}
    
    @objc func toggleShapeButtonTapped() {}
}

extension BaseMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        setLocationOnMap(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationIfPossible()
    }
}
