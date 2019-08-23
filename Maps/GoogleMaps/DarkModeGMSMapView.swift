//
//  DarkModeGMSMapView.swift
//  Maps
//
//  Created by Sebastian Osiński on 23/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import GoogleMaps

class DarkModeGMSMapView: GMSMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateStyle()
    }
    
    override init(frame: CGRect, camera: GMSCameraPosition) {
        super.init(frame: frame, camera: camera)
        
        updateStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        updateStyle()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateStyle()
    }
    
    private func updateStyle() {
        if traitCollection.userInterfaceStyle == .dark, let darkStyleUrl = Bundle.main.url(forResource: "gm_dark_style", withExtension: "json") {
            mapStyle = try? .init(contentsOfFileURL: darkStyleUrl)
        } else {
            mapStyle = nil
        }
    }
}

