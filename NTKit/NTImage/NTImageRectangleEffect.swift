//
//  NTImageRectangleEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTImageRectangleEffect: NTImageEffect {
    var rect: CGRect = CGRectZero
    var color: UIColor = UIColor.clearColor()
    
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
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
