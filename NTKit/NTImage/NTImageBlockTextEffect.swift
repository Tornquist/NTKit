//
//  NTImageBlockTextEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 4/5/16.
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

public class NTImageBlockTextEffect: NTImageEffect {
    var anchor: CGPoint = CGPointZero
    var anchorPosition: NTImageEffectAnchorPosition = .Center
    var width: CGFloat = 0
    var text: NSString = ""
    var font: UIFont = UIFont.systemFontOfSize(12)
    var fontColor: UIColor = UIColor.clearColor()
    
    enum TextScaleDirection {
        case None
        case Equal
        case GreaterThan
        case LessThan
    }
    
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, maxWidth: CGFloat, text: String, baseFont: UIFont, fontColor: UIColor) {
        self.init()
        self.anchor = anchor
        self.anchorPosition = anchorPosition
        self.width = maxWidth
        self.text = (text as NSString)
        self.font = baseFont
        self.fontColor = fontColor
    }
    
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, maxWidth: CGFloat, text: String, baseFont: UIFont, fontColor: UIColor, capitalize: Bool) {
        let newText = capitalize ? text.uppercaseString : text
        self.init(anchor: anchor, anchorPosition: anchorPosition, maxWidth: maxWidth, text: newText, baseFont: baseFont, fontColor: fontColor)
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        
        var basePosition = CGPointZero
        
        var textFonts: [UIFont] = []
        var textRects: [CGRect] = []
        let textRows = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        for row in textRows {
            let calculatedFont = calculateFontFor(row, withBase: font)
            
            let renderedTextSize = row.sizeWithAttributes([NSFontAttributeName: calculatedFont])
            let adjustedTextSize = CGSizeMake(ceil(renderedTextSize.width), ceil(renderedTextSize.height))
            let textRect = CGRectMake(basePosition.x, basePosition.y, adjustedTextSize.width, adjustedTextSize.height)
            
            textFonts.append(calculatedFont)
            textRects.append(textRect)
            
            basePosition = CGPointMake(basePosition.x, basePosition.y + adjustedTextSize.height)
        }
        
        let totalHeight = textRects.reduce(0, combine: {$0 + $1.height})
        let offset = calculateOffsetFrom(CGSizeMake(self.width, totalHeight))
        
        for i in 0..<textRows.count {
            let textAttributes = [
                NSFontAttributeName: textFonts[i],
                NSForegroundColorAttributeName: self.fontColor
            ]
            
            textRows[i].drawInRect(textRects[i].offsetBy(dx: offset.x, dy: offset.y), withAttributes: textAttributes)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func calculateOffsetFrom(size: CGSize) -> CGPoint {
        let xLeft   = self.anchor.x
        let xCenter = self.anchor.x - size.width/2
        let xRight  = self.anchor.x - size.width
        let yTop    = self.anchor.y
        let yCenter = self.anchor.y - size.height/2
        let yBottom = self.anchor.y - size.height
        
        switch anchorPosition {
        case .Center:
            return CGPointMake(xCenter, yCenter)
        case .CenterLeft:
            return CGPointMake(xLeft, yCenter)
        case .CenterRight:
            return CGPointMake(xRight, yCenter)
        case .CenterTop:
            return CGPointMake(xCenter, yTop)
        case .CenterBottom:
            return CGPointMake(xCenter, yBottom)
        case .TopLeft:
            return CGPointMake(xLeft, yTop)
        case .TopRight:
            return CGPointMake(xRight, yTop)
        case .BottomLeft:
            return CGPointMake(xLeft, yBottom)
        case .BottomRight:
            return CGPointMake(xRight, yBottom)
        }
    }
    
    func calculateFontFor(text: NSString, withBase font: UIFont) -> UIFont {
        var adjustedFont = font
        var calculatedFont = adjustedFont
        var scaleDirection = self.compare(text, toWidthWithFont: adjustedFont)
        var continueScaling = (scaleDirection != .Equal)
        
        while continueScaling {
            calculatedFont = adjustedFont
            
            switch scaleDirection {
            case .GreaterThan:
                adjustedFont = adjustedFont.fontWithSize(adjustedFont.pointSize * 0.99)
            case .LessThan:
                adjustedFont = adjustedFont.fontWithSize(adjustedFont.pointSize * 1.01)
            default:
                scaleDirection = .None
            }
            
            let newScaleDirection = self.compare(text, toWidthWithFont: adjustedFont)
            continueScaling = (newScaleDirection == scaleDirection)
        }
        
        if (scaleDirection == .GreaterThan) {
            calculatedFont = adjustedFont
        }
        
        return calculatedFont
    }
    
    func compare(text: NSString, toWidthWithFont font: UIFont) -> TextScaleDirection {
        let renderedSize = text.sizeWithAttributes([NSFontAttributeName: font])
        let adjustedSize = CGSizeMake(ceil(renderedSize.width), ceil(renderedSize.height))
        
        if adjustedSize.width > self.width {
            return .GreaterThan
        } else if adjustedSize.width < self.width {
            return .LessThan
        }
        return .Equal
    }
}
