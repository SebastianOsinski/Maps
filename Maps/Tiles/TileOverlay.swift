//
//  TileOverlay.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import MapKit

class TileOverlay: MKTileOverlay {
    static let tileManager = TileManager()
    
    init() {
        super.init(urlTemplate: nil)
        
        maximumZ = 19
        minimumZ = 1
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        Self.tileManager.loadTile(at: TilePath(path)) { loadResult in
            DispatchQueue.main.async {
                result(loadResult.success, loadResult.failure)
            }
        }
    }
}
