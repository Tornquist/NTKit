//
//  NTCropHelper.swift
//  NTKit
//
//  Created by Nathan Tornquist on 5/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import Foundation

class NTCropHelper {
    static func scale(path: UIBezierPath, toPoint point: CGPoint, withScale scale: CGFloat) -> UIBezierPath {
        let pathCopy = path.copy() as! UIBezierPath
        let boundingBox = pathCopy.bounds
        let originTranslation = CGAffineTransformMakeTranslation(-boundingBox.minX, -boundingBox.minY)
        let newOriginTranslation = CGAffineTransformMakeTranslation(point.x, point.y)
        
        let sizeScale = CGAffineTransformMakeScale(scale, scale)
        
        pathCopy.applyTransform(originTranslation)
        pathCopy.applyTransform(sizeScale)
        pathCopy.applyTransform(newOriginTranslation)
        return pathCopy
    }
}