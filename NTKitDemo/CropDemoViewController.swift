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
    @IBOutlet weak var topImageView: NTImageView!
    @IBOutlet weak var bottomImageView: NTImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performCropAction()
    }
    
    func performCropAction() {
        let image = UIImage(named: "Landscape")
        topImageView.image = image
        bottomImageView.image = crop(image)
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func crop(image: UIImage?) -> UIImage? {
        guard image != nil else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(image!.size, false, 0)
        bigPath().addClip()
        image!.drawAtPoint(CGPointZero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func bigPath() -> UIBezierPath {
        var paths: [UIBezierPath] = []
        paths.append(angledPath())
        paths.append(circlePath())
        paths.append(stripePath())
        
        let resultPath = UIBezierPath()
        for path in paths {
            resultPath.appendPath(path)
        }
        
        return resultPath
    }
    
    func angledPath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(10, 10),
            CGPointMake(1800, 200),
            CGPointMake(1500, 900),
            CGPointMake(50, 300)
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
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: CGRectMake(0, 900, 100, 100))
    }
    
    func stripePath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(500, 1080),
            CGPointMake(1400, 0),
            CGPointMake(1500, 0),
            CGPointMake(600, 1080)
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