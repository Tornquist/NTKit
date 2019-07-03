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

/**
 NTImageBlockTextEffect draws text in a block over a UIImage.  The provided text will
 be scaled to match the width given.  The anchor point and style can be configured, and the
 height will be determined based on the width and the line breaks in the text.
 */
open class NTImageBlockTextEffect: NTImageEffect {
    open var anchor: CGPoint = CGPoint.zero
    open var anchorPosition: NTImageEffectAnchorPosition = .Center
    open var width: CGFloat = 0
    var _text: NSString = ""
    open var rawText: NSString {
        get {
            return _text
        }
    }
    open var text: NSString {
        get {
            return capitalize ? _text.uppercased as NSString : _text
        }
        set {
            _text = newValue
        }
    }
    open var font: UIFont = UIFont.systemFont(ofSize: 12)
    open var fontColor: UIColor = UIColor.clear
    open var trailingTargetCharacterThreshold: Float = 0.33
    open var capitalize: Bool = false
    open var alpha: CGFloat = 1 {
        didSet {
            if alpha < 0 { alpha = 0 }
            if alpha > 1 { alpha = 1 }
        }
    }
    
    enum TextScaleDirection {
        case none
        case equal
        case greaterThan
        case lessThan
    }
    
    /**
     Initializes Block Text effect with default values
     */
    public override init() {
    }
    
    /**
     Draws the text provided within the given maximum width using the provided font characteristics.  The font size will
     be adjusted on a per-line basic to make sure that every line is as close to the maximum width as possible.  The height
     of the final text is completely based on the rendered text and is variable.
     
     - parameter anchor: The reference point used to draw the text.
     - parameter anchorPosition: The positioning of the anchor provided relative to the rest of the drawing.
     - parameter maxWidth: The maximum width of the rendered text.
     - parameter text: The text to draw on the screen
     - parameter baseFont: The font used as a base for calculations.  The font size will be scaled up and down as needed.
     - parameter fontColor: The color the font should be drawn with.
     */
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, maxWidth: CGFloat, text: String, baseFont: UIFont, fontColor: UIColor) {
        self.init()
        self.anchor = anchor
        self.anchorPosition = anchorPosition
        self.width = maxWidth
        self.text = (text as NSString)
        self.font = baseFont
        self.fontColor = fontColor
    }
    
    /**
     Draws the text provided within the given maximum width using the provided font characteristics.  The font size will
     be adjusted on a per-line basic to make sure that every line is as close to the maximum width as possible.  The height
     of the final text is completely based on the rendered text and is variable.
     
     - parameter anchor: The reference point used to draw the text.
     - parameter anchorPosition: The positioning of the anchor provided relative to the rest of the drawing.
     - parameter maxWidth: The maximum width of the rendered text.
     - parameter text: The text to draw on the screen
     - parameter baseFont: The font used as a base for calculations.  The font size will be scaled up and down as needed.
     - parameter fontColor: The color the font should be drawn with.
     - parameter capitalize: Used to decide if the input text should be automatically capitalized.
     */
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, maxWidth: CGFloat, text: String, baseFont: UIFont, fontColor: UIColor, capitalize: Bool) {
        let newText = capitalize ? text.uppercased() : text
        self.init(anchor: anchor, anchorPosition: anchorPosition, maxWidth: maxWidth, text: newText, baseFont: baseFont, fontColor: fontColor)
        self.capitalize = capitalize
    }
    
    /**
     Draws the text provided within the given maximum width using the provided font characteristics.  The font size will
     be adjusted on a per-line basic to make sure that every line is as close to the maximum width as possible.  The height
     of the final text is completely based on the rendered text and is variable.
     
     - parameter anchor: The reference point used to draw the text.
     - parameter anchorPosition: The positioning of the anchor provided relative to the rest of the drawing.
     - parameter maxWidth: The maximum width of the rendered text.
     - parameter text: The text to draw on the screen
     - parameter baseFont: The font used as a base for calculations.  The font size will be scaled up and down as needed.
     - parameter fontColor: The color the font should be drawn with.
     - parameter capitalize: Used to decide if the input text should be automatically capitalized.
     - parameter trailingTargetCharacterThreshold: The ratio used to decide whether the final trailing text should be its own line, or if it should be joined with
                                                   the line above. The default value is 0.33. This means that if the final text is longer than 33% of the target line length it
                                                   will be drawn on its own line.
     */
    public convenience init(anchor: CGPoint, anchorPosition: NTImageEffectAnchorPosition, maxWidth: CGFloat, text: String, baseFont: UIFont, fontColor: UIColor, capitalize: Bool, trailingTargetCharacterThreshold: Float) {
        self.init(anchor: anchor, anchorPosition: anchorPosition, maxWidth: maxWidth, text: text, baseFont: baseFont, fontColor: fontColor, capitalize: capitalize)
        self.trailingTargetCharacterThreshold = trailingTargetCharacterThreshold
    }
    
    open override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        
        var basePosition = CGPoint.zero
        
        var textFonts: [UIFont] = []
        var textRects: [CGRect] = []
        let textRows = generateTextRows()
        
        for row in textRows {
            let calculatedFont = calculateFontFor(row as NSString, withBase: font)
            
            let renderedTextSize = row.size(withAttributes: [NSAttributedString.Key.font: calculatedFont])
            let adjustedTextSize = CGSize(width: ceil(renderedTextSize.width), height: ceil(renderedTextSize.height))
            let textRect = CGRect(x: basePosition.x, y: basePosition.y, width: adjustedTextSize.width, height: adjustedTextSize.height)
            
            textFonts.append(calculatedFont)
            textRects.append(textRect)
            
            basePosition = CGPoint(x: basePosition.x, y: basePosition.y + adjustedTextSize.height)
        }
        
        let totalHeight = textRects.reduce(0, {$0 + $1.height})
        let offset = calculateOffsetFrom(CGSize(width: self.width, height: totalHeight))
        
        for i in 0..<textRows.count {
            let textAttributes = [
                NSAttributedString.Key.font: textFonts[i],
                NSAttributedString.Key.foregroundColor: self.fontColor.withAlphaComponent(alpha)
            ]
            
            textRows[i].draw(in: textRects[i].offsetBy(dx: offset.x, dy: offset.y), withAttributes: textAttributes)
        }
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage!
    }
    
    //MARK: - Methods for Breaking Text into Rows
    
    func generateTextRows() -> [String] {
        let targetNumberOfCharacters = calculateTargetNumberOfCharacters(forFont: font, inWidth: self.width)
        
        var baseRows = self.text.components(separatedBy: CharacterSet.newlines)
        baseRows = baseRows.map({$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)})
        let cleanRows = baseRows.map({generateTextRows(fromString: $0, withTarget: targetNumberOfCharacters)}).reduce([], +)
        
        return cleanRows
    }
    
    func calculateTargetNumberOfCharacters(forFont font: UIFont, inWidth width: CGFloat) -> Int {
        var targetCharacterString = ""
        var generatedWidth: CGFloat = 0
        while (generatedWidth < width) {
            let renderedTextSize = targetCharacterString.size(withAttributes: [NSAttributedString.Key.font: font])
            let adjustedTextSize = CGSize(width: ceil(renderedTextSize.width), height: ceil(renderedTextSize.height))
            generatedWidth = adjustedTextSize.width
            targetCharacterString = targetCharacterString + "a"
        }
        return targetCharacterString.count - 1
    }
    
    func generateTextRows(fromString string: String, withTarget targetCharacters: Int) -> [String] {
        let words = string.components(separatedBy: " ")
        var retVal: [String] = []
        
        var stringA = ""
        var stringB = ""
        var wordIndex = 0
        
        while wordIndex < words.count {
            if stringB != "" {
                stringB = stringB + " "
            }
            stringB = stringB + words[wordIndex]
            
            if stringB.count > targetCharacters {
                let aDiff = abs(stringA.count - targetCharacters)
                let bDiff = abs(stringB.count - targetCharacters)
                if aDiff < bDiff {
                    retVal.append(stringA)
                    wordIndex = wordIndex - 1 //Account for later increment
                } else {
                    retVal.append(stringB)
                }
                
                stringA = ""
                stringB = ""
            }
            
            wordIndex = wordIndex + 1
            
            stringA = stringB
        }
        
        // Make sure no words are dropped
        if (stringB != "") {
            if Float(stringB.count) < Float(targetCharacters)*trailingTargetCharacterThreshold && retVal.count > 0 {
                retVal[retVal.count-1] = retVal[retVal.count-1] + " " + stringB
            } else {
                retVal.append(stringB)
            }
        }
        
        return retVal
    }
    
    //MARK: - Methods for Final Rendering
    
    func calculateOffsetFrom(_ size: CGSize) -> CGPoint {
        let xLeft   = self.anchor.x
        let xCenter = self.anchor.x - size.width/2
        let xRight  = self.anchor.x - size.width
        let yTop    = self.anchor.y
        let yCenter = self.anchor.y - size.height/2
        let yBottom = self.anchor.y - size.height
        
        switch anchorPosition {
        case .Center:
            return CGPoint(x: xCenter, y: yCenter)
        case .CenterLeft:
            return CGPoint(x: xLeft, y: yCenter)
        case .CenterRight:
            return CGPoint(x: xRight, y: yCenter)
        case .CenterTop:
            return CGPoint(x: xCenter, y: yTop)
        case .CenterBottom:
            return CGPoint(x: xCenter, y: yBottom)
        case .TopLeft:
            return CGPoint(x: xLeft, y: yTop)
        case .TopRight:
            return CGPoint(x: xRight, y: yTop)
        case .BottomLeft:
            return CGPoint(x: xLeft, y: yBottom)
        case .BottomRight:
            return CGPoint(x: xRight, y: yBottom)
        }
    }
    
    //MARK: - Methods for Scaling Font Sizes
    
    func calculateFontFor(_ text: NSString, withBase font: UIFont) -> UIFont {
        var adjustedFont = font
        var calculatedFont = adjustedFont
        var scaleDirection = self.compare(text, toWidthWithFont: adjustedFont)
        var continueScaling = (scaleDirection != .equal)
        
        while continueScaling {
            calculatedFont = adjustedFont
            
            switch scaleDirection {
            case .greaterThan:
                adjustedFont = adjustedFont.withSize(adjustedFont.pointSize * 0.99)
            case .lessThan:
                adjustedFont = adjustedFont.withSize(adjustedFont.pointSize * 1.01)
            default:
                scaleDirection = .none
            }
            
            let newScaleDirection = self.compare(text, toWidthWithFont: adjustedFont)
            continueScaling = (newScaleDirection == scaleDirection)
        }
        
        if (scaleDirection == .greaterThan) {
            calculatedFont = adjustedFont
        }
        
        return calculatedFont
    }
    
    func compare(_ text: NSString, toWidthWithFont font: UIFont) -> TextScaleDirection {
        let renderedSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let adjustedSize = CGSize(width: ceil(renderedSize.width), height: ceil(renderedSize.height))
        
        if adjustedSize.width > self.width {
            return .greaterThan
        } else if adjustedSize.width < self.width {
            return .lessThan
        }
        return .equal
    }
    
    //MARK: - Mock KVO System
    
    override open func acceptedKeys() -> [String] {
        return ["anchor", "anchorPosition", "width", "text", "font", "fontColor",
                "trailingTargetCharacterThreshold", "capitalize", "alpha"]
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
        case "text":
            if obj is String || obj is NSString {
                text = obj as! NSString
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
        case "trailingTargetCharacterThreshold":
            if obj is Float || obj is CGFloat {
                trailingTargetCharacterThreshold = obj as! Float
                return true
            }
            return false
        case "capitalize":
            if obj is Bool {
                capitalize = obj as! Bool
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
        case "anchorPosition":
            return anchorPosition
        case "width":
            return width
        case "text":
            return rawText // Return unmodified text
        case "font":
            return font
        case "fontColor":
            return fontColor
        case "trailingTargetCharacterThreshold":
            return trailingTargetCharacterThreshold
        case "capitalize":
            return capitalize
        case "alpha":
            return alpha
        default:
            return nil
        }
    }
}
