//
//  NTImageProgressCircleEffect.swift
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

import UIKit

/**
 NTImageProgressCircleEffect can be used to draw circular progress indicators anywhere on
 a UIImage.  The drawing will run from the start angle to end angle, and will fill in the
 space between the inner and outer radius.  It is also possible to outline the inner and
 outer circles completely if so desired.
 */
open class NTImageProgressCircleEffect: NTImageEffect {
    open var center: CGPoint = CGPoint.zero
    open var color: UIColor = UIColor.clear
    open var innerRadius: CGFloat = 0
    open var outerRadius: CGFloat = 0
    open var startAngle: CGFloat = CGFloat(M_PI+M_PI_2)
    open var endAngle: CGFloat = 0
    open var strokeInnerCircle: Bool = false
    open var strokeOuterCircle: Bool = false
    open var strokeWidth: CGFloat = 5
    open var alpha: CGFloat = 1 {
        didSet {
            if alpha < 0 { alpha = 0 }
            if alpha > 1 { alpha = 1 }
        }
    }
    open var percent: CGFloat {
        get {
            return (endAngle - CGFloat(M_PI+M_PI_2))/CGFloat(M_PI*2)
        }
        set {
            let angle = (newValue >= 1) ? CGFloat(3*M_PI+M_PI_2) : (CGFloat(M_PI+M_PI_2) + newValue*CGFloat(M_PI*2))
            self.endAngle = angle
        }
    }
    open var strokeCircle: Bool {
        get {
            return strokeInnerCircle && strokeOuterCircle
        }
        set {
            strokeInnerCircle = newValue
            strokeOuterCircle = newValue
        }
    }
    
    /**
     Initializes Progress Circle effect with default values
     */
    public override init() {
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
    
    /**
     Draws an arc filled based on the percentage provided.  The arc will start at 12-o'clock and completely wrap around
     the circle if a value greater than or equal to 1 is provided for the percentage.
     
     The inner and outer circle will be stroked at 5% of the arc's thickness if strokeCircle is true.
     The arc's thickness will be 1/3 of radius provided.
     
     - parameter center: The center point of the effect in the coordinate system of the image it will be applied to.
     - parameter radius: The radius of the outer edge of the arc.
     - parameter percent: The percentage of the arc to fill in.
     - parameter color: The fill color of the drawing.
     - parameter strokeCircle: A boolean used to decide if the inner and outer circle should be drawn.
     */
    public convenience init(center: CGPoint, radius: CGFloat, percent: CGFloat, color: UIColor, strokeCircle: Bool) {
        let endAngle = (percent >= 1) ? CGFloat(3*M_PI+M_PI_2) : (CGFloat(M_PI+M_PI_2) + percent*CGFloat(M_PI*2))
        
        self.init(center: center,
                  innerRadius: radius*0.33,
                  outerRadius: radius,
                  startAngle: CGFloat(M_PI+M_PI_2),
                  endAngle: endAngle,
                  color: color,
                  strokeInnerCircle: strokeCircle,
                  strokeOuterCircle: strokeCircle,
                  strokeWidth: radius*0.0166)
    }
    
    open override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        color.withAlphaComponent(alpha).setStroke()
        color.withAlphaComponent(alpha).setFill()
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addArc(withCenter: center, radius: outerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        path.fill()
        
        if strokeInnerCircle {
            let inner = UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: 0, endAngle: CGFloat(M_PI)*2, clockwise: true)
            inner.addArc(withCenter: center, radius: innerRadius + strokeWidth, startAngle: CGFloat(M_PI)*2, endAngle: 0, clockwise: false)
            inner.fill()
        }
        if strokeOuterCircle {
            let outer = UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: 0, endAngle: CGFloat(M_PI)*2, clockwise: true)
            outer.addArc(withCenter: center, radius: outerRadius - strokeWidth, startAngle: CGFloat(M_PI)*2, endAngle: 0, clockwise: false)
            outer.fill()
        }
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return processedImage!
    }
    
    //MARK: - Movk KVO System
    
    override open func acceptedKeys() -> [String] {
        return ["center", "color", "innerRadius", "outerRadius", "startAngle", "endAngle",
                "strokeInnerCircle", "strokeOuterCircle", "strokeWidth", "percent", "strokeCircle", "alpha"]
    }
    
    override open func changeValueOf(_ key: String, to obj: Any) -> Bool{
        let options = acceptedKeys()
        guard options.contains(key) else {
            return false
        }
        
        switch key {
        case "center":
            if obj is CGPoint {
                center = obj as! CGPoint
                return true
            }
            return false
        case "color":
            if obj is UIColor {
                color = obj as! UIColor
                return true
            }
            return false
        case "innerRadius":
            if obj is CGFloat {
                innerRadius = obj as! CGFloat
                return true
            }
            if obj is Float {
                innerRadius = CGFloat(obj as! Float)
                return true
            }
            return false
        case "outerRadius":
            if obj is CGFloat {
                outerRadius = obj as! CGFloat
                return true
            }
            if obj is Float {
                outerRadius = CGFloat(obj as! Float)
                return true
            }
            return false
        case "startAngle":
            if obj is CGFloat {
                startAngle = obj as! CGFloat
                return true
            }
            if obj is Float {
                startAngle = CGFloat(obj as! Float)
                return true
            }
            return false
        case "endAngle":
            if obj is CGFloat {
                endAngle = obj as! CGFloat
                return true
            }
            if obj is Float {
                endAngle = CGFloat(obj as! Float)
                return true
            }
            return false
        case "percent":
            if obj is CGFloat {
                percent = obj as! CGFloat
                return true
            }
            if obj is Float {
                percent = CGFloat(obj as! Float)
                return true
            }
            return false
        case "strokeWidth":
            if obj is CGFloat {
                strokeWidth = obj as! CGFloat
                return true
            }
            if obj is Float {
                strokeWidth = CGFloat(obj as! Float)
                return true
            }
            return false
        case "strokeInnerCircle":
            if obj is Bool {
                strokeInnerCircle = obj as! Bool
                return true
            }
            return false
        case "strokeOuterCircle":
            if obj is Bool {
                strokeOuterCircle = obj as! Bool
                return true
            }
            return false
        case "strokeCircle":
            if obj is Bool {
                strokeCircle = obj as! Bool
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
        case "center":
            return center
        case "color":
            return color
        case "innerRadius":
            return innerRadius
        case "outerRadius":
            return outerRadius
        case "startAngle":
            return startAngle
        case "endAngle":
            return endAngle
        case "percent":
            return percent
        case "strokeWidth":
            return strokeWidth
        case "strokeInnerCircle":
            return strokeInnerCircle
        case "strokeOuterCircle":
            return strokeOuterCircle
        case "strokeCircle":
            return strokeCircle
        case "alpha":
            return alpha
        default:
            return nil
        }
    }
}
