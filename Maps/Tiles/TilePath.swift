//
//  TilePath.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import MapKit

struct TilePath: Hashable {
    let zoom: UInt
    let x: UInt
    let y: UInt
}

extension TilePath {
    init(_ path: MKTileOverlayPath) {
        self.init(zoom: UInt(path.z), x: UInt(path.x), y: UInt(path.y))
    }
}
