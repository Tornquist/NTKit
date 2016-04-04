//
//  NTImageShadeEffect.swift
//  NTKit
//
//  Created by Nathan Tornquist on 4/4/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public enum NTImageShadeEffectShadeShape {
    case Full
    case Top
    case Bottom
    case Left
    case Right
    case TriangleTopLeft
    case TriangleTopRight
    case TriangleBottomLeft
    case TriangleBottomRight
    case SquareTopLeft
    case SquareTopRight
    case SquareBottomRight
    case SquareBottomLeft
}

public class NTImageShadeEffect: NTImageEffect {
    var shadeShape: NTImageShadeEffectShadeShape = .Full
    var color: UIColor = UIColor.clearColor()
    
    public convenience init(shape: NTImageShadeEffectShadeShape, color: UIColor) {
        self.init()
        self.shadeShape = shape
        self.color = color
    }
    
    public override func apply(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPointZero)
        let ctx = UIGraphicsGetCurrentContext()
        color.setStroke()
        color.setFill()
        
        createPath(ctx, size: image.size)
        CGContextDrawPath(ctx, .FillStroke)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func createPath(ctx: CGContext?, size: CGSize) {
        guard ctx != nil else {
            return
        }
        
        let topLeft      = CGPoint(x: 0, y: 0)
        let topRight     = CGPoint(x: size.width, y: 0)
        let bottomLeft   = CGPoint(x: 0, y: size.height)
        let bottomRight  = CGPoint(x: size.width, y: size.height)
        let center       = CGPoint(x: size.width/2, y: size.height/2)
        let centerTop    = CGPoint(x: size.width/2, y: 0)
        let centerLeft   = CGPoint(x: 0, y: size.height/2)
        let centerRight  = CGPoint(x: size.width, y: size.height/2)
        let centerBottom = CGPoint(x: size.width/2, y: size.height)
        
        switch shadeShape {
        case .Full:
            pathFromPoints(ctx, points: [topLeft, topRight, bottomRight, bottomLeft])
        case .Top:
            pathFromPoints(ctx, points: [topLeft, topRight, centerRight, centerLeft])
        case .Bottom:
            pathFromPoints(ctx, points: [centerLeft, centerRight, bottomRight, bottomLeft])
        case .Left:
            pathFromPoints(ctx, points: [topLeft, centerTop, centerBottom, bottomLeft])
        case .Right:
            pathFromPoints(ctx, points: [centerTop, topRight, bottomRight, centerBottom])
        case .TriangleTopLeft:
            pathFromPoints(ctx, points: [topLeft, topRight, bottomLeft])
        case .TriangleTopRight:
            pathFromPoints(ctx, points: [topLeft, topRight, bottomRight])
        case .TriangleBottomLeft:
            pathFromPoints(ctx, points: [topLeft, bottomRight, bottomLeft])
        case .TriangleBottomRight:
            pathFromPoints(ctx, points: [bottomLeft, topRight, bottomRight])
        case .SquareTopLeft:
            pathFromPoints(ctx, points: [topLeft, centerTop, center, centerLeft])
        case .SquareTopRight:
            pathFromPoints(ctx, points: [centerTop, topRight, centerRight, center])
        case .SquareBottomRight:
            pathFromPoints(ctx, points: [center, centerRight, bottomRight, centerBottom])
        case .SquareBottomLeft:
            pathFromPoints(ctx, points: [centerLeft, center, centerBottom, bottomLeft])
        }
    }
    
    func pathFromPoints(ctx: CGContext?, points: [CGPoint]) {
        guard points.count > 0 else {
            return
        }
        CGContextMoveToPoint(ctx, points[0].x, points[0].y)
        for i in 1..<points.count {
            CGContextAddLineToPoint(ctx, points[i].x, points[i].y)
        }
        CGContextAddLineToPoint(ctx, points[0].x, points[0].y)
    }
}
