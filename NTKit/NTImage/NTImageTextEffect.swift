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
open class NTImageTextEffect: NTImageEffect {
    open var anchor: CGPoint = CGPoint.zero
    open var text: String = ""
    open var font: UIFont = UIFont.systemFont(ofSize: 12)
    open var fontColor: UIColor = UIColor.clear
    open var anchorPosition: NTImageEffectAnchorPosition = .Center
    open var alignment: NSTextAlignment = .center
    open var maxWidth: CGFloat? = nil
    var angle: CGFloat = 0
    open var degreeAngle: CGFloat {
        get {
            return self.angle*180/CGFloat(M_PI)
        }
        set {
            self.angle = CGFloat(M_PI)/180*newValue
        }
    }
    open var radianAngle: CGFloat {
        get {
            return self.angle
        }
        set {
            self.angle = newValue
        }
    }
    open var alpha: CGFloat = 1 {
        didSet {
            if alpha < 0 { alpha = 0 }
            if alpha > 1 { alpha = 1 }
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
    
    open override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let ctx = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint.zero)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.alignment
        
        let textAttributes = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.fontColor.withAlphaComponent(alpha),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let textToDraw = (maxWidth == nil) ? self.text : generateWrappedText(from: self.text)
        let textRect = generateTextRect(for: textToDraw)
    
        ctx?.translateBy(x: self.anchor.x, y: self.anchor.y)
        ctx?.rotate(by: self.angle)
        
        let adjustedTextRect = CGRect(x: textRect.minX-self.anchor.x,
                                          y: textRect.minY-self.anchor.y,
                                          width: textRect.width,
                                          height: textRect.height)
        
        textToDraw.draw(in: adjustedTextRect, withAttributes: textAttributes)
        
        ctx?.rotate(by: -self.angle)
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage!
    }
    
    func generateTextRect(for text: String) -> CGRect {
        let renderedSize = text.size(attributes: [NSFontAttributeName: font])
        let adjustedSize = CGSize(width: ceil(renderedSize.width), height: ceil(renderedSize.height))
        
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
            return CGRect(x: xCenter, y: yCenter, width: width, height: height)
        case .CenterLeft:
            return CGRect(x: xLeft, y: yCenter, width: width, height: height)
        case .CenterRight:
            return CGRect(x: xRight, y: yCenter, width: width, height: height)
        case .CenterTop:
            return CGRect(x: xCenter, y: yTop, width: width, height: height)
        case .CenterBottom:
            return CGRect(x: xCenter, y: yBottom, width: width, height: height)
        case .TopLeft:
            return CGRect(x: xLeft, y: yTop, width: width, height: height)
        case .TopRight:
            return CGRect(x: xRight, y: yTop, width: width, height: height)
        case .BottomLeft:
            return CGRect(x: xLeft, y: yBottom, width: width, height: height)
        case .BottomRight:
            return CGRect(x: xRight, y: yBottom, width: width, height: height)
        }
    }
    
    func generateWrappedText(from string: String) -> String {
        guard self.maxWidth != nil else {
            return string
        }
        
        let lines = string.components(separatedBy: CharacterSet.newlines)
        
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
    
    func adjust(text: String, renderedWithFont font: UIFont, andMaxWidth maxWidth: CGFloat) -> String {
        var remainingWords = text.components(separatedBy: CharacterSet.whitespaces)
        
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
            let renderedSize = workingString.size(attributes: [NSFontAttributeName: font])
            let adjustedSize = CGSize(width: ceil(renderedSize.width), height: ceil(renderedSize.height))
            
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
    
    func safeAppend(_ newString: String, to oldString: String, withSpacer spacer: String) -> String {
        if oldString == "" {
            return newString
        } else {
            return oldString + spacer + newString
        }
    }
    
    // MARK: - Mock KVO System
    
    override open func acceptedKeys() -> [String] {
        return ["anchor", "text", "font", "fontColor", "anchorPosition", "alignment", "maxWidth", "degreeAngle", "radianAngle", "alpha"]
    }
    
    override open func changeValueOf(_ key: String, to obj: Any) -> Bool {
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
            if obj is Float {
                maxWidth = CGFloat(obj as! Float)
                return true
            }
            return false
        case "radianAngle":
            if obj is CGFloat {
                radianAngle = obj as! CGFloat
                return true
            }
            if obj is Float {
                radianAngle = CGFloat(obj as! Float)
                return true
            }
            return false
        case "degreeAngle":
            if obj is CGFloat {
                degreeAngle = obj as! CGFloat
                return true
            }
            if obj is Float {
                degreeAngle = CGFloat(obj as! Float)
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
        case "alpha":
            return alpha
        default:
            return nil
        }
    }
}

