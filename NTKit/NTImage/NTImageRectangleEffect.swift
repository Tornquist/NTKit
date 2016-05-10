//
//  NTImageRectangleEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/25/16.
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

/**
 NTImageRectangleEffect is used to draw a colored rectangle anywhere on a UIImage.
 */
public class NTImageRectangleEffect: NTImageEffect {
    public var rect: CGRect {
        get {
            var x: CGFloat = 0
            var y: CGFloat = 0
            switch anchorPosition {
            case .TopLeft:
                x = anchor.x
                y = anchor.y
            case .CenterTop:
                x = anchor.x - width/2
                y = anchor.y
            case .TopRight:
                x = anchor.x - width
                y = anchor.y
            case .CenterLeft:
                x = anchor.x
                y = anchor.y - height/2
            case .Center:
                x = anchor.x - width/2
                y = anchor.y - height/2
            case .CenterRight:
                x = anchor.x - width
                y = anchor.y - height/2
            case .BottomLeft:
                x = anchor.x
                y = anchor.y - height
            case .CenterBottom:
                x = anchor.x - width/2
                y = anchor.y - height
            case .BottomRight:
                x = anchor.x - width
                y = anchor.y - height
            }
            return CGRectMake(x, y, width, height)
        }
        set {
            self.anchor = CGPointMake(newValue.origin.x, newValue.origin.y)
            self.anchorPosition = .TopLeft
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    public var color: UIColor = UIColor.clearColor()
    public var anchor: CGPoint = CGPointZero
    public var anchorPosition: NTImageEffectAnchorPosition = .TopLeft
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    
    /**
     Initializes Rectangle effect with default values
     */
    public override init() {
    }
    
    public convenience init(rect: CGRect, color: UIColor) {
        self.init()
        self.color = color
        self.anchor = CGPointMake(rect.origin.x, rect.origin.y)
        self.anchorPosition = .TopLeft
        self.width = rect.width
        self.height = rect.height
    }
    
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, width: CGFloat, height: CGFloat, color: UIColor) {
        self.init()
        self.anchor = anchor
        self.anchorPosition = anchorPosition
        self.width = width
        self.height = height
        self.color = color
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        let ctx = UIGraphicsGetCurrentContext()
        color.setStroke()
        color.setFill()
        
        CGContextStrokeRect(ctx, rect)
        CGContextFillRect(ctx, rect)
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage
    }
    
    //MARK: - Mock KVO System
    
    override public func acceptedKeys() -> [String] {
        return ["rect", "color", "anchor", "anchorPosition", "width", "height"]
    }
    
    override public func changeValueOf(key: String, to obj: Any) -> Bool {
        let options = acceptedKeys()
        guard options.contains(key) else {
            return false
        }
        
        switch key {
        case "rect":
            if obj is CGRect {
                rect = obj as! CGRect
                return true
            }
            return false
        case "color":
            if obj is UIColor {
                color = obj as! UIColor
                return true
            }
            return false
        case "anchor":
            if obj is CGPoint {
                anchor = obj as! CGPoint
                return true
            }
            return false
        case "anchorPosition":
            if obj is NTImageEffectAnchorPosition {
                anchorPosition = obj as! NTImageEffectAnchorPosition
                return true
            }
            return false
        case "width":
            if obj is CGFloat {
                width = obj as! CGFloat
                return true
            }
            return false
        case "height":
            if obj is CGFloat {
                height = obj as! CGFloat
                return true
            }
            return false
        default:
            return false
        }
    }

    override public func getValueOf(key: String) -> Any? {
        let options = acceptedKeys()
        guard options.contains(key) else {
            return nil
        }
        
        switch key {
        case "rect":
            return rect
        case "color":
            return color
        case "anchor":
            return anchor
        case "anchorPosition":
            return anchorPosition
        case "width":
            return width
        case "height":
            return height
        default:
            return nil
        }
    }
}
