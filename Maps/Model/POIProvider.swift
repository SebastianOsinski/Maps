//
//  POIProvider.swift
//  Maps
//
//  Created by Sebastian Osiński on 23/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import Foundation

final class POIProvider {
    func loadPOIs(_ completion: @escaping ([POI]?) -> ()) {
        let url = Bundle.main.url(forResource: "POIs", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let pois = try! JSONDecoder().decode([POI].self, from: data)
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let url = Bundle.main.url(forResource: "POIs", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let pois = try? JSONDecoder().decode([POI].self, from: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(pois)
            }
        }
    }
}
