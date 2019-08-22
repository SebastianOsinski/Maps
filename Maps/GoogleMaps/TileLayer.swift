//
//  TileLayer.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import GoogleMaps

final class TileLayer: GMSTileLayer {
    static let tileManager = TileManager.shared
    
    override func requestTileFor(x: UInt, y: UInt, zoom: UInt, receiver: GMSTileReceiver) {
        let tilePath = TilePath(zoom: zoom, x: x, y: y)
        
        Self.tileManager.loadTile(at: tilePath) { result in
            receiver.receiveTileWith(
                x: x,
                y: y,
                zoom: zoom,
                image: result.map(UIImage.init).success.flatMap { $0 }
            )
        }
        
    }
}
