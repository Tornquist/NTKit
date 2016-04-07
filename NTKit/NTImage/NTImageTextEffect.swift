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

/**
 NTImageTextEffect allows for easy drawing of text over a UIImage.  The color, font, anchor positing,
 and text alignment can all be configured.  This is traditional text drawing.
 */
public class NTImageTextEffect: NTImageEffect {
    public var anchor: CGPoint = CGPointZero
    public var text: NSString = ""
    public var font: UIFont = UIFont.systemFontOfSize(12)
    public var fontColor: UIColor = UIColor.clearColor()
    public var anchorPosition: NTImageEffectAnchorPosition = .Center
    public var alignment: NSTextAlignment = .Center
    
    public convenience init(anchor: CGPoint, text: String, fontColor: UIColor) {
        self.init()
        self.anchor = anchor
        self.text = (text as NSString)
        self.fontColor = fontColor
    }
    
    public convenience init(anchor: CGPoint, text: String, font: UIFont, fontColor: UIColor) {
        self.init(anchor: anchor, text: text, fontColor: fontColor)
        self.font = font
    }
    
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, text: String, font: UIFont, fontColor: UIColor) {
        self.init(anchor: anchor, text: text, font: font, fontColor: fontColor)
        self.anchorPosition = anchorPosition
    }
    
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, text: String, textAlignment: NSTextAlignment, font: UIFont, fontColor: UIColor) {
        self.init(anchor: anchor, anchorPosition: anchorPosition, text: text, font: font, fontColor: fontColor)
        self.alignment = textAlignment
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let textAttributes = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.fontColor,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let textRect = generateTextRect()
        self.text.drawInRect(textRect, withAttributes: textAttributes)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func generateTextRect() -> CGRect {
        let renderedSize = text.sizeWithAttributes([NSFontAttributeName: font])
        let adjustedSize = CGSizeMake(ceil(renderedSize.width), ceil(renderedSize.height))
        
        let xLeft   = self.anchor.x
        let xCenter = self.anchor.x - adjustedSize.width/2
        let xRight  = self.anchor.x - adjustedSize.width
        let yTop    = self.anchor.y
        let yCenter = self.anchor.y - adjustedSize.height/2
        let yBottom = self.anchor.y - adjustedSize.height
        let width   = adjustedSize.width
        let height  = adjustedSize.height
        
        switch anchorPosition {
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

