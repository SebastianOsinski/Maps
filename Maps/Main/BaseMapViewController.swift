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
    
    private let switchMapModeButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchMapModeButtonItem.target = self
        switchMapModeButtonItem.action = #selector(switchMapModeButtonTapped)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(currentLocationButtonTapped)),
            switchMapModeButtonItem
        ]
        
        locationManager.delegate = self
    }
    
    func setupMapView(_ mapView: UIView) {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setMapModeButton(mode: MapMode) {
        switchMapModeButtonItem.image = mode.buttonImage
    }
    
    func requestLocationIfPossible() {
        guard [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) else {
            locationManager.requestWhenInUseAuthorization()
            
            return
        }
        
        locationManager.requestLocation()
    }
    
    func setLocationOnMap(_ location: CLLocation) {}
    
    @objc func currentLocationButtonTapped() {}
    
    @objc func switchMapModeButtonTapped() {}
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
