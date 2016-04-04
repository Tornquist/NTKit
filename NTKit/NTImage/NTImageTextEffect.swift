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

public class NTImageTextEffect: NTImageEffect {
    var position: CGPoint = CGPointZero
    var text: String = ""
    var font: UIFont = UIFont.systemFontOfSize(12)
    var fontColor: UIColor = UIColor.clearColor()
    
    public convenience init(position: CGPoint, text: String, fontColor: UIColor) {
        self.init()
        self.position = position
        self.text = text
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
        
        let textRect = CGRectMake(position.x, position.y, image.size.width, image.size.height)
        (text as NSString).drawInRect(textRect, withAttributes: textAttributes)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

