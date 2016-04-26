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
    public var rect: CGRect = CGRectZero
    public var color: UIColor = UIColor.clearColor()
    
    /**
     Initializes Rectangle effect with default values
     */
    public override init() {
    }
    
    public convenience init(rect: CGRect, color: UIColor) {
        self.init()
        self.rect = rect
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
        return ["rect", "color"]
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
        default:
            return false
        }
    }

}
