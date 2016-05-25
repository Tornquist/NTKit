//
//  NTCropOverlayView.swift
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

import UIKit

class NTCropOverlayView: UIView {
    
    var cropPath: UIBezierPath? = nil
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.configureView()
    }
    
    func configureView() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        if let path = pathInFrame() {
            UIColor.redColor().colorWithAlphaComponent(0.6).setFill()
            UIColor.redColor().colorWithAlphaComponent(0.6).setStroke()
            path.fill()
        }
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false // Overlay ignores touchces
    }
    
    // MARK: - Path Methods
    
    func pathInFrame() -> UIBezierPath? {
        guard cropPath != nil else { return nil }
        
        return scale(cropPath!, toPoint: CGPointZero, withScale: self.frame.width/cropPath!.bounds.width)
    }
    
    func scale(path: UIBezierPath, toPoint point: CGPoint, withScale scale: CGFloat) -> UIBezierPath {
        let boundingBox = path.bounds
        let originTranslation = CGAffineTransformMakeTranslation(-boundingBox.minX, -boundingBox.minY)
        let newOriginTranslation = CGAffineTransformMakeTranslation(point.x, point.y)
        
        let sizeScale = CGAffineTransformMakeScale(scale, scale)
        
        path.applyTransform(originTranslation)
        path.applyTransform(newOriginTranslation)
        path.applyTransform(sizeScale)
        return path
    }
    
    func aspectRatio() -> CGFloat {
        guard cropPath != nil else {
            return 1
        }
        
        let bounds = cropPath!.bounds
        return bounds.width/bounds.height
    }
}