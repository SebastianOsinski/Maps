//
//  BaseMapViewController.swift
//  Maps
//
//  Created by Sebastian Osiński on 23/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

class BaseMapViewController<MapView: UIView>: UIViewController {
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
    
    let mapView = MapView(frame: .zero)
    
    private let switchMapModeButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        switchMapModeButtonItem.target = self
        switchMapModeButtonItem.action = #selector(switchMapModeButtonTapped)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(currentLocationButtonTapped)),
            switchMapModeButtonItem
        ]
    }
    
    func setMapModeButton(mode: MapMode) {
        switchMapModeButtonItem.image = mode.buttonImage
    }
    
    @objc func currentLocationButtonTapped() {}
    
    @objc func switchMapModeButtonTapped() {}
}
