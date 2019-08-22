//
//  Result.swift
//  Maps
//
//  Created by Sebastian Osiński on 22/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

extension Result {
    var success: Success? {
        switch self {
        case .success(let success): return success
        case .failure: return nil
        }
    }
    
    var failure: Failure? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}
