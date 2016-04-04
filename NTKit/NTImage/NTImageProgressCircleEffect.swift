//
//  NTImageProgressCircleEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 4/4/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTImageProgressCircleEffect: NTImageEffect {
    var center: CGPoint = CGPointZero
    var color: UIColor = UIColor.clearColor()
    var innerRadius: CGFloat = 0
    var outerRadius: CGFloat = 0
    var startAngle: CGFloat = 0
    var endAngle: CGFloat = 0
    var strokeInnerCircle: Bool = false
    var strokeOuterCircle: Bool = false
    var strokeWidth: CGFloat = 5
    
    /**
     Draws a filled circle from the starting angle to the end angle.  The circle will be filled started at the innerRadius
     distance from the center and ending at the outerRadius distance from the center.
     
     - parameter center: The center point of the effect in the coordinate system of the image it will be applied to.
     - parameter innerRadius: The distance from the center drawing will begin.
     - parameter outerRadius: The distance from the center drawing will end.
     - parameter startAngle: The angle to the starting point of the arc, measured in radians from the positive x-axis.
     - parameter endAngle: The angle to the ending point of the arc, measured in radians from the positive x-axis.
     - parameter color: The fill color of the drawing.
     */
    public convenience init(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        self.init()
        self.center = center
        self.color = color
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    /**
     Draws a filled circle from the starting angle to the end angle.  The circle will be filled started at the innerRadius
     distance from the center and ending at the outerRadius distance from the center.
     
     - parameter center: The center point of the effect in the coordinate system of the image it will be applied to.
     - parameter innerRadius: The distance from the center drawing will begin.
     - parameter outerRadius: The distance from the center drawing will end.
     - parameter startAngle: The angle to the starting point of the arc, measured in radians from the positive x-axis.
     - parameter endAngle: The angle to the ending point of the arc, measured in radians from the positive x-axis.
     - parameter color: The fill color of the drawing.
     - parameter strokeInnerCircle: A boolean value that decides if a complete circle should be drawn along the inner radius.
     - parameter strokeOuterCircle: A boolean value that decides if a complete circle should be drawn along the outer radius.
     */
    public convenience init(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor, strokeInnerCircle: Bool, strokeOuterCircle: Bool) {
        self.init(center: center, innerRadius: innerRadius, outerRadius: outerRadius, startAngle: startAngle, endAngle: endAngle, color: color)
        self.strokeInnerCircle = strokeInnerCircle
        self.strokeOuterCircle = strokeOuterCircle
    }
    
    /**
     Draws a filled circle from the starting angle to the end angle.  The circle will be filled started at the innerRadius
     distance from the center and ending at the outerRadius distance from the center.
     
     - parameter center: The center point of the effect in the coordinate system of the image it will be applied to.
     - parameter innerRadius: The distance from the center drawing will begin.
     - parameter outerRadius: The distance from the center drawing will end.
     - parameter startAngle: The angle to the starting point of the arc, measured in radians from the positive x-axis.
     - parameter endAngle: The angle to the ending point of the arc, measured in radians from the positive x-axis.
     - parameter color: The fill color of the drawing.
     - parameter strokeInnerCircle: A boolean value that decides if a complete circle should be drawn along the inner radius.
     - parameter strokeOuterCircle: A boolean value that decides if a complete circle should be drawn along the outer radius.
     - parameter strokeWidth: The width of the path if strokeInnerCircle or strokeOuterCircle is true. The path will be drawn inwards. Nothing will be drawn outside of the outer radius.
     */
    public convenience init(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor, strokeInnerCircle: Bool, strokeOuterCircle: Bool, strokeWidth: CGFloat) {
        self.init(center: center, innerRadius: innerRadius, outerRadius: outerRadius,
                  startAngle: startAngle, endAngle: endAngle, color: color,
                  strokeInnerCircle: strokeInnerCircle, strokeOuterCircle: strokeOuterCircle)
        self.strokeWidth = strokeWidth
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        color.setStroke()
        color.setFill()
        
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addArcWithCenter(center, radius: outerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        path.fill()
        
        if strokeInnerCircle {
            let inner = UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            inner.addArcWithCenter(center, radius: innerRadius + strokeWidth, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            inner.fill()
        }
        if strokeOuterCircle {
            let outer = UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            outer.addArcWithCenter(center, radius: outerRadius - strokeWidth, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            outer.fill()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
