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
public class NTImageBlockTextEffect: NTImageEffect {
    public var anchor: CGPoint = CGPointZero
    public var anchorPosition: NTImageEffectAnchorPosition = .Center
    public var width: CGFloat = 0
    var _text: NSString = ""
    public var text: NSString {
        get {
            return _text
        }
        set {
            _text = self.capitalize ? newValue.uppercaseString : newValue
        }
    }
    public var font: UIFont = UIFont.systemFontOfSize(12)
    public var fontColor: UIColor = UIColor.clearColor()
    public var trailingTargetCharacterThreshold: Float = 0.33
    public var capitalize: Bool = false
    
    enum TextScaleDirection {
        case None
        case Equal
        case GreaterThan
        case LessThan
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
        let newText = capitalize ? text.uppercaseString : text
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
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        
        var basePosition = CGPointZero
        
        var textFonts: [UIFont] = []
        var textRects: [CGRect] = []
        let textRows = generateTextRows()
        
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
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage
    }
    
    //MARK: - Methods for Breaking Text into Rows
    
    func generateTextRows() -> [String] {
        let targetNumberOfCharacters = calculateTargetNumberOfCharacters(forFont: font, inWidth: self.width)
        
        var baseRows = self.text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        baseRows = baseRows.map({$0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())})
        let cleanRows = baseRows.map({generateTextRows(fromString: $0, withTarget: targetNumberOfCharacters)}).reduce([], combine: +)
        
        return cleanRows
    }
    
    func calculateTargetNumberOfCharacters(forFont font: UIFont, inWidth width: CGFloat) -> Int {
        var targetCharacterString = ""
        var generatedWidth: CGFloat = 0
        while (generatedWidth < width) {
            let renderedTextSize = targetCharacterString.sizeWithAttributes([NSFontAttributeName: font])
            let adjustedTextSize = CGSizeMake(ceil(renderedTextSize.width), ceil(renderedTextSize.height))
            generatedWidth = adjustedTextSize.width
            targetCharacterString = targetCharacterString + "a"
        }
        return targetCharacterString.characters.count - 1
    }
    
    func generateTextRows(fromString string: String, withTarget targetCharacters: Int) -> [String] {
        let words = string.componentsSeparatedByString(" ")
        var retVal: [String] = []
        
        var stringA = ""
        var stringB = ""
        var wordIndex = 0
        
        while wordIndex < words.count {
            if stringB != "" {
                stringB = stringB + " "
            }
            stringB = stringB + words[wordIndex]
            
            if stringB.characters.count > targetCharacters {
                let aDiff = abs(stringA.characters.count - targetCharacters)
                let bDiff = abs(stringB.characters.count - targetCharacters)
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
            if Float(stringB.characters.count) < Float(targetCharacters)*trailingTargetCharacterThreshold && retVal.count > 0 {
                retVal[retVal.count-1] = retVal[retVal.count-1] + " " + stringB
            } else {
                retVal.append(stringB)
            }
        }
        
        return retVal
    }
    
    //MARK: - Methods for Final Rendering
    
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
    
    //MARK: - Methods for Scaling Font Sizes
    
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
