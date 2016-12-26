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
open class NTImageRectangleEffect: NTImageEffect {
    open var rect: CGRect {
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
            return CGRect(x: x, y: y, width: width, height: height)
        }
        set {
            self.anchor = CGPoint(x: newValue.origin.x, y: newValue.origin.y)
            self.anchorPosition = .TopLeft
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    open var color: UIColor = UIColor.clear
    open var anchor: CGPoint = CGPoint.zero
    open var anchorPosition: NTImageEffectAnchorPosition = .TopLeft
    open var width: CGFloat = 0
    open var height: CGFloat = 0
    open var alpha: CGFloat = 1 {
        didSet {
            if alpha < 0 { alpha = 0 }
            if alpha > 1 { alpha = 1 }
        }
    }
    
    /**
     Initializes Rectangle effect with default values
     */
    public override init() {
    }
    
    public convenience init(rect: CGRect, color: UIColor) {
        self.init()
        self.color = color
        self.anchor = CGPoint(x: rect.origin.x, y: rect.origin.y)
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
    
    open override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        let ctx = UIGraphicsGetCurrentContext()
        color.withAlphaComponent(alpha).setStroke()
        color.withAlphaComponent(alpha).setFill()
        
        ctx?.stroke(rect)
        ctx?.fill(rect)
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage!
    }
    
    //MARK: - Mock KVO System
    
    override open func acceptedKeys() -> [String] {
        return ["rect", "color", "anchor", "anchorPosition", "width", "height", "alpha"]
    }
    
    override open func changeValueOf(_ key: String, to obj: Any) -> Bool {
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
            if obj is Float {
                width = CGFloat(obj as! Float)
                return true
            }
            return false
        case "height":
            if obj is CGFloat {
                height = obj as! CGFloat
                return true
            }
            if obj is Float {
                height = CGFloat(obj as! Float)
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
            if obj is Bool {
                alpha = (obj as! Bool) ? 1 : 0
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
        case "alpha":
            return alpha
        default:
            return nil
        }
    }
}
