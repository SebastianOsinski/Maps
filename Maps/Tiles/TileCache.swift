//
//  TileCache.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import Foundation

private final class TilePathCacheKey: NSObject {
    private let path: TilePath
    
    init(_ path: TilePath) {
        self.path = path
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return path == (object as? TilePathCacheKey)?.path
    }
    
    override var hash: Int {
        return path.hashValue
    }
}

final class TileCache {
    private let fileManager = FileManager.default
    
    private let workerQueue = DispatchQueue(label: "dev.osinski.Maps.TileCache.workerQueue", qos: .utility, attributes: .concurrent)
    private let memoryCache = NSCache<TilePathCacheKey, NSData>()
    
    private lazy var cacheDirectory: URL = {
        try! self.fileManager.url(for: .cachesDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
    }()
    
    func saveTile(_ data: Data, at path: TilePath) {
        memoryCache.setObject(data as NSData, forKey: TilePathCacheKey(path))
        
        let url = fileUrl(for: path)
        workerQueue.async { [fileManager] in
            try! fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            try! data.write(to: url, options: .atomic)
        }
    }
    
    func loadTile(at path: TilePath, completion: @escaping (Data?) -> ()) {
        if let memCached = memoryCache.object(forKey: TilePathCacheKey(path)) {
            return completion(memCached as Data)
        }
        
        let url = fileUrl(for: path)
        
        workerQueue.async { [fileManager, memoryCache] in
            guard fileManager.fileExists(atPath: url.path) else {
                print("No cached tile for \(path)")
                return completion(nil)
            }
            
            print("Cached tile for \(path)")
            
            guard let data = try? Data(contentsOf: url) else {
                return completion(nil)
            }
            
            memoryCache.setObject(data as NSData, forKey: TilePathCacheKey(path))
            
            completion(data)
        }
    }
    
    private func fileUrl(for path: TilePath) -> URL {
        return cacheDirectory
            .appendingPathComponent("TileCache")
            .appendingPathComponent("\(path.zoom)/\(path.x)/\(path.y).tile")
    }
}
