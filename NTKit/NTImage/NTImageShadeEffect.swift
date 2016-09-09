//
//  NTImageShadeEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 4/4/16.
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

public enum NTImageShadeEffectShadeShape: String {
    case Full
    case Top
    case Bottom
    case Left
    case Right
    case TriangleTopLeft
    case TriangleTopRight
    case TriangleBottomLeft
    case TriangleBottomRight
    case SquareTopLeft
    case SquareTopRight
    case SquareBottomRight
    case SquareBottomLeft
}

/**
 NTImageShadeEffect will tint a section of a provided UIImage.
 */
open class NTImageShadeEffect: NTImageEffect {
    open var shadeShape: NTImageShadeEffectShadeShape = .Full
    open var color: UIColor = UIColor.clear
    open var alpha: CGFloat = 1 {
        didSet {
            if alpha < 0 { alpha = 0 }
            if alpha > 1 { alpha = 1 }
        }
    }
    
    /**
     Initializes Shade effect with default values
     */
    public override init() {
    }
    
    public convenience init(shape: NTImageShadeEffectShadeShape, color: UIColor) {
        self.init()
        self.shadeShape = shape
        self.color = color
    }
    
    open override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        let ctx = UIGraphicsGetCurrentContext()
        color.withAlphaComponent(alpha).setStroke()
        color.withAlphaComponent(alpha).setFill()
        
        createPath(ctx, size: image.size)
        ctx?.drawPath(using: .fillStroke)
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage!
    }
    
    func createPath(_ ctx: CGContext?, size: CGSize) {
        guard ctx != nil else {
            return
        }
        
        let topLeft      = CGPoint(x: 0, y: 0)
        let topRight     = CGPoint(x: size.width, y: 0)
        let bottomLeft   = CGPoint(x: 0, y: size.height)
        let bottomRight  = CGPoint(x: size.width, y: size.height)
        let center       = CGPoint(x: size.width/2, y: size.height/2)
        let centerTop    = CGPoint(x: size.width/2, y: 0)
        let centerLeft   = CGPoint(x: 0, y: size.height/2)
        let centerRight  = CGPoint(x: size.width, y: size.height/2)
        let centerBottom = CGPoint(x: size.width/2, y: size.height)
        
        switch shadeShape {
        case .Full:
            pathFromPoints(ctx, points: [topLeft, topRight, bottomRight, bottomLeft])
        case .Top:
            pathFromPoints(ctx, points: [topLeft, topRight, centerRight, centerLeft])
        case .Bottom:
            pathFromPoints(ctx, points: [centerLeft, centerRight, bottomRight, bottomLeft])
        case .Left:
            pathFromPoints(ctx, points: [topLeft, centerTop, centerBottom, bottomLeft])
        case .Right:
            pathFromPoints(ctx, points: [centerTop, topRight, bottomRight, centerBottom])
        case .TriangleTopLeft:
            pathFromPoints(ctx, points: [topLeft, topRight, bottomLeft])
        case .TriangleTopRight:
            pathFromPoints(ctx, points: [topLeft, topRight, bottomRight])
        case .TriangleBottomLeft:
            pathFromPoints(ctx, points: [topLeft, bottomRight, bottomLeft])
        case .TriangleBottomRight:
            pathFromPoints(ctx, points: [bottomLeft, topRight, bottomRight])
        case .SquareTopLeft:
            pathFromPoints(ctx, points: [topLeft, centerTop, center, centerLeft])
        case .SquareTopRight:
            pathFromPoints(ctx, points: [centerTop, topRight, centerRight, center])
        case .SquareBottomRight:
            pathFromPoints(ctx, points: [center, centerRight, bottomRight, centerBottom])
        case .SquareBottomLeft:
            pathFromPoints(ctx, points: [centerLeft, center, centerBottom, bottomLeft])
        }
    }
    
    func pathFromPoints(_ ctx: CGContext?, points: [CGPoint]) {
        guard points.count > 0 else {
            return
        }
        ctx?.move(to: CGPoint(x: points[0].x, y: points[0].y))
        for i in 1..<points.count {
            ctx?.addLine(to: CGPoint(x: points[i].x, y: points[i].y))
        }
        ctx?.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
    }
    
    //MARK: - Mock KVO System
    
    override open func acceptedKeys() -> [String] {
        return ["shadeShape", "color", "alpha"]
    }
    
    override open func changeValueOf(_ key: String, to obj: Any) -> Bool {
        let options = acceptedKeys()
        guard options.contains(key) else {
            return false
        }
        
        switch key {
        case "shadeShape":
            if obj is NTImageShadeEffectShadeShape {
                shadeShape = obj as! NTImageShadeEffectShadeShape
                return true
            }
            return false
        case "color":
            if obj is UIColor {
                color = obj as! UIColor
                return true
            }
            return false
        case "alpha":
            if obj is CGFloat {
                alpha = obj as! CGFloat
                return true
            }
            if obj is Float {
                alpha = CGFloat(obj as! Float)
                return true
            }
            return false
        default:
            return false
        }
    }
    
    override open func getValueOf(_ key: String) -> Any? {
        let options = acceptedKeys()
        guard options.contains(key) else {
            return nil
        }
        
        switch key {
        case "shadeShape":
            return shadeShape
        case "color":
            return color
        case "alpha":
            return alpha
        default:
            return nil
        }
    }
}
