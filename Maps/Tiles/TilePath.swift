//
//  TilePath.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import MapKit

struct TilePath: Hashable {
    let zoom: Int
    let x: Int
    let y: Int
}

extension TilePath {
    init(_ path: MKTileOverlayPath) {
        self.init(zoom: path.z, x: path.x, y: path.y)
    }
}
