//
//  NTImageTextEffect.swift
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

public enum NTImageTextEffectAnchorPosition {
    case Center        // Dead Center
    case CenterLeft    // Vertically Center, Left Align
    case CenterRight   // Vertically Center, Right Align
    case CenterTop     // Horizontally Center, Align Top
    case CenterBottom  // Horizontally Center, Align Bottom
    case TopLeft       // Top Left Corner
    case TopRight      // Top Right Corner
    case BottomLeft    // Bottom Left Corner
    case BottomRight   // Bottom Right Corner
}

public class NTImageTextEffect: NTImageEffect {
    var position: CGPoint = CGPointZero
    var text: NSString = ""
    var font: UIFont = UIFont.systemFontOfSize(12)
    var fontColor: UIColor = UIColor.clearColor()
    var positionStyle: NTImageTextEffectAnchorPosition = .Center
    
    public convenience init(position: CGPoint, text: String, fontColor: UIColor) {
        self.init()
        self.position = position
        self.text = (text as NSString)
        self.fontColor = fontColor
    }
    
    public convenience init(position: CGPoint, text: String, font: UIFont, fontColor: UIColor) {
        self.init(position: position, text: text, fontColor: fontColor)
        self.font = font
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        
        let textAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: fontColor
        ]
        
        let textRect = generateTextRect()
        text.drawInRect(textRect, withAttributes: textAttributes)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func generateTextRect() -> CGRect {
        let renderedSize = text.sizeWithAttributes([NSFontAttributeName: font])
        let adjustedSize = CGSizeMake(ceil(renderedSize.width), ceil(renderedSize.height))
        
        let xLeft   = position.x
        let xCenter = position.x - adjustedSize.width/2
        let xRight  = position.x - adjustedSize.width
        let yTop    = position.y
        let yCenter = position.y - adjustedSize.height/2
        let yBottom = position.y - adjustedSize.height
        let width   = adjustedSize.width
        let height  = adjustedSize.height
        
        switch positionStyle {
        case .Center:
            return CGRectMake(xCenter, yCenter, width, height)
        case .CenterLeft:
            return CGRectMake(xLeft, yCenter, width, height)
        case .CenterRight:
            return CGRectMake(xRight, yCenter, width, height)
        case .CenterTop:
            return CGRectMake(xCenter, yTop, width, height)
        case .CenterBottom:
            return CGRectMake(xCenter, yBottom, width, height)
        case .TopLeft:
            return CGRectMake(xLeft, yTop, width, height)
        case .TopRight:
            return CGRectMake(xRight, yTop, width, height)
        case .BottomLeft:
            return CGRectMake(xLeft, yBottom, width, height)
        case .BottomRight:
            return CGRectMake(xRight, yBottom, width, height)
        }
    }
}

