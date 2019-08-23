//
//  UIImage.swift
//  Maps
//
//  Created by Sebastian Osiński on 23/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

extension UIImage {
    static func emoji(_ emoji: String) -> UIImage {
        let nsString = emoji as NSString
        let font = UIFont.systemFont(ofSize: 30)
        let attributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: [.font: font])

        return UIGraphicsImageRenderer(size: imageSize).image { context in
            UIColor.clear.set()
            UIRectFill(CGRect(origin: .zero, size: imageSize))
            nsString.draw(at: CGPoint.zero, withAttributes: attributes)
        }
    }
}
