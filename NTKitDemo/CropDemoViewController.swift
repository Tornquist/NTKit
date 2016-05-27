//
//  CropDemoViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 5/22/16.
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
import NTKit

class CropDemoViewController: UIViewController {
    @IBOutlet weak var topImageView: NTCropView!
    @IBOutlet weak var bottomImageView: NTImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup NTCropView
        self.topImageView.cropPath = bigPath()
        let image = UIImage(named: "Landscape")
        topImageView.image = image
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cropButtonPressed(sender: AnyObject) {
        bottomImageView.image = topImageView.crop()
    }
    
    func crop(image: UIImage?) -> UIImage? {
        guard image != nil else {
            return nil
        }
        
        // Build Path
        var path = bigPath()
        path = scale(path, toPoint: CGPointMake(50, 540), withScale: 0.5)
        
        // Mask original image
        UIGraphicsBeginImageContextWithOptions(image!.size, false, 0)
        path.addClip()
        image!.drawAtPoint(CGPointZero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Crop masked image to size (visible at min and max positions, no extra whitespace)
        let boundingBox = path.bounds
        UIGraphicsBeginImageContext(boundingBox.size)
        newImage.drawAtPoint(CGPointMake(-boundingBox.minX, -boundingBox.minY))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    // MARK: - Path Modification
    func scale(path: UIBezierPath, toPoint point: CGPoint, withScale scale: CGFloat) -> UIBezierPath {
        let boundingBox = path.bounds
        let originTranslation = CGAffineTransformMakeTranslation(-boundingBox.minX, -boundingBox.minY)
        let newOriginTranslation = CGAffineTransformMakeTranslation(point.x, point.y)
        
        let sizeScale = CGAffineTransformMakeScale(scale, scale)
        
        path.applyTransform(originTranslation)
        path.applyTransform(newOriginTranslation)
        path.applyTransform(sizeScale)
        return path
    }
    
    // MARK: - Path Generation
    
    func bigPath() -> UIBezierPath {
        var paths: [UIBezierPath] = []
        paths.append(circlePath())
        paths.append(stripePath(260))
        paths.append(stripePath(460))
        paths.append(stripePath(660))
        
        
        let resultPath = UIBezierPath()
        for path in paths {
            resultPath.appendPath(path)
        }
        
        return resultPath
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: CGRectMake(660, 240, 600, 600))
    }
    
    func stripePath(startX: CGFloat) -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(startX, 980),
            CGPointMake(startX+900, 100),
            CGPointMake(startX+1000, 100),
            CGPointMake(startX+100, 980)
        ]
        
        let path = UIBezierPath()
        for (index, point) in points.enumerate() {
            if index == 0 {
                path.moveToPoint(point)
            } else {
                path.addLineToPoint(point)
            }
        }
        path.closePath()
        return path
    }
}