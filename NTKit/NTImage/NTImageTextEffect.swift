//
//  NTImageTextEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 4/4/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

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

