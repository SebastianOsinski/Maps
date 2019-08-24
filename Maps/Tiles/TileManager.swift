//
//  TileManager.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import Foundation
import class UIKit.UIImage

final class TileManager {
    static let shared = TileManager()
    
    private let urlSession = URLSession.shared
    private let cache = TileCache()
    private let baseUrl = URL(string: "https://tile.openstreetmap.org")!
    
    private let maxZoom = 19
    
    private lazy var maxTile: Data = {
        return UIImage(named: "max_tile")!.pngData()!
    }()
    
    func loadTile(at path: TilePath, completion: @escaping (Result<Data, Error>) -> ()) {
        guard path.zoom <= maxZoom else {
            return completion(.success(maxTile))
        }
        
        cache.loadTile(at: path) { [weak self] data in
            if let data = data {
                return completion(.success(data))
            }
            
            self?.fetchTile(at: path) { [weak self] result in
                completion(result.map { data in
                    self?.cache.saveTile(data, at: path)
                    
                    return data
                })
            }
        }
    }
    
    private func fetchTile(at path: TilePath, completion: @escaping (Result<Data, Error>) -> ()) {
        log.info("Downloading tile at \(path)...")
        
        urlSession
            .dataTask(with: url(for: path)) { (data, response, error) in
                // Improve response handling, data might not be image data
                if let error = error {
                    log.error("Errow downloading tile at \(path): \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let data = data {
                    log.info("Tile downloaded at \(path)")
                    completion(.success(data))
                } else {
                    fatalError()
                }
            }
            .resume()
    }
    
    private func url(for path: TilePath) -> URL {
        return baseUrl.appendingPathComponent("\(path.zoom)/\(path.x)/\(path.y).png")
    }
}
