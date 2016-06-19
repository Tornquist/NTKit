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
    public var text: String = ""
    public var font: UIFont = UIFont.systemFontOfSize(12)
    public var fontColor: UIColor = UIColor.clearColor()
    public var anchorPosition: NTImageEffectAnchorPosition = .Center
    public var alignment: NSTextAlignment = .Center
    public var maxWidth: CGFloat? = nil
    var angle: CGFloat = 0
    public var degreeAngle: CGFloat {
        get {
            return self.angle*180/CGFloat(M_PI)
        }
        set {
            self.angle = CGFloat(M_PI)/180*newValue
        }
    }
    public var radianAngle: CGFloat {
        get {
            return self.angle
        }
        set {
            self.angle = newValue
        }
    }
    
    /**
     Initializes Text effect with default values
     */
    public override init() {
    }
    
    public convenience init(anchor: CGPoint, text: String, fontColor: UIColor) {
        self.init()
        self.anchor = anchor
        self.text = text
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
    
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, text: String, textAlignment: NSTextAlignment, font: UIFont, fontColor: UIColor, maxWidth: CGFloat) {
        self.init(anchor: anchor, anchorPosition: anchorPosition, text: text, textAlignment: textAlignment, font: font, fontColor: fontColor)
        self.maxWidth = maxWidth
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let ctx = UIGraphicsGetCurrentContext()
        image.drawAtPoint(CGPointZero)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let textAttributes = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.fontColor,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let textToDraw = (maxWidth == nil) ? self.text : generateWrappedText(from: self.text)
        let textRect = generateTextRect(for: textToDraw)
    
        CGContextTranslateCTM(ctx, self.anchor.x, self.anchor.y)
        CGContextRotateCTM(ctx, self.angle)
        
        let adjustedTextRect = CGRectMake(textRect.minX-self.anchor.x,
                                          textRect.minY-self.anchor.y,
                                          textRect.width,
                                          textRect.height)
        
        textToDraw.drawInRect(adjustedTextRect, withAttributes: textAttributes)
        
        CGContextRotateCTM(ctx, -self.angle)
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage
    }
    
    func generateTextRect(for text: String) -> CGRect {
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
    
    func generateWrappedText(from string: String) -> String {
        guard self.maxWidth != nil else {
            return string
        }
        
        let newlineChars = NSCharacterSet.newlineCharacterSet()
        let lines = string.utf16.split { newlineChars.characterIsMember($0) }.flatMap(String.init)
        
        var resultString: String = ""
        
        for line in lines {
            let correctedText = adjust(text: line, renderedWithFont: font, andMaxWidth: self.maxWidth!)
            
            if resultString == "" {
                resultString = correctedText
            } else {
                resultString = resultString + "\n" + correctedText
            }
        }
        
        return resultString
    }
    
    // MARK: - Wrap Text Helper Methods
    
    func adjust(text text: String, renderedWithFont font: UIFont, andMaxWidth maxWidth: CGFloat) -> String {
        let whitespaceChars = NSCharacterSet.whitespaceCharacterSet()
        var remainingWords = text.utf16.split { whitespaceChars.characterIsMember($0) }.flatMap(String.init)
        
        var processedString = ""
        
        var workingString = ""
        var lastWorkingString = ""
        
        while (true) {
            guard remainingWords.count != 0 else {
                // Append final string if needed
                if workingString != "" {
                    processedString = safeAppend(workingString, to: processedString, withSpacer: "\n")
                }
                break
            }
            
            workingString = safeAppend(remainingWords[0], to: workingString, withSpacer: " ")
            
            // Calculate Current Size
            let renderedSize = workingString.sizeWithAttributes([NSFontAttributeName: font])
            let adjustedSize = CGSizeMake(ceil(renderedSize.width), ceil(renderedSize.height))
            
            // Evaluate Width
            if adjustedSize.width < maxWidth {
                remainingWords.removeFirst()
            } else {
                // When width is too large, evaluate if there is only one word. If a single word is too long,
                // then the word will break the maxWidth rule. Words will not currently be split
                if lastWorkingString != "" {
                    processedString = safeAppend(lastWorkingString, to: processedString, withSpacer: "\n")
                } else {
                    processedString = safeAppend(workingString, to: processedString, withSpacer: "\n")
                    remainingWords.removeFirst()
                }
                workingString = ""
            }
            
            lastWorkingString = workingString
        }
        
        return processedString
    }
    
    func safeAppend(newString: String, to oldString: String, withSpacer spacer: String) -> String {
        if oldString == "" {
            return newString
        } else {
            return oldString + spacer + newString
        }
    }
    
    // MARK: - Mock KVO System
    
    override public func acceptedKeys() -> [String] {
        return ["anchor", "text", "font", "fontColor", "anchorPosition", "alignment", "maxWidth", "degreeAngle", "radianAngle"]
    }
    
    override public func changeValueOf(key: String, to obj: Any) -> Bool {
        let options = acceptedKeys()
        guard options.contains(key) else {
            return false
        }
        
        switch key {
        case "anchor":
            if obj is CGPoint {
                anchor = obj as! CGPoint
                return true
            }
            return false
        case "text":
            if obj is String || obj is NSString {
                text = obj as! String
                return true
            }
            return false
        case "font":
            if obj is UIFont {
                font = obj as! UIFont
                return true
            }
            return false
        case "fontColor":
            if obj is UIColor {
                fontColor = obj as! UIColor
                return true
            }
            return false
        case "anchorPosition":
            if obj is NTImageEffectAnchorPosition {
                anchorPosition = obj as! NTImageEffectAnchorPosition
                return true
            }
            return false
        case "alignment":
            if obj is NSTextAlignment {
                alignment = obj as! NSTextAlignment
                return true
            }
            return false
        case "maxWidth":
            if obj is CGFloat {
                maxWidth = obj as? CGFloat
                return true
            }
            return false
        case "radianAngle":
            if obj is CGFloat {
                radianAngle = obj as! CGFloat
                return true
            }
            return false
        case "degreeAngle":
            if obj is CGFloat {
                degreeAngle = obj as! CGFloat
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
        case "anchor":
            return anchor
        case "text":
            return text
        case "font":
            return font
        case "fontColor":
            return fontColor
        case "anchorPosition":
            return anchorPosition
        case "alignment":
            return alignment
        case "maxWidth":
            return maxWidth
        case "radianAngle":
            return radianAngle
        case "degreeAngle":
            return degreeAngle
        default:
            return nil
        }
    }
}

