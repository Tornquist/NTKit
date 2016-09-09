//
//  NTCropHelper.swift
//  NTKit
//
//  Created by Nathan Tornquist on 5/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//
//  Hosted on github at github.com/Tornquist/NTKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

class NTCropHelper {
    static func scale(_ path: UIBezierPath, toPoint point: CGPoint, withScale scale: CGFloat) -> UIBezierPath {
        let pathCopy = path.copy() as! UIBezierPath
        let boundingBox = pathCopy.bounds
        let originTranslation = CGAffineTransform(translationX: -boundingBox.minX, y: -boundingBox.minY)
        let newOriginTranslation = CGAffineTransform(translationX: point.x, y: point.y)
        
        let sizeScale = CGAffineTransform(scaleX: scale, y: scale)
        
        pathCopy.apply(originTranslation)
        pathCopy.apply(sizeScale)
        pathCopy.apply(newOriginTranslation)
        return pathCopy
    }
}
