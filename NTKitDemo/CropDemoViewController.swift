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
    
    var currentPathIndex: Int = 0
    var paths: [UIBezierPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePaths()
        
        // Setup NTCropView
        self.topImageView.cropPath = currentPath()
        let image = UIImage(named: "Landscape")
        topImageView.image = image
    }
    
    // MARK: - Button Events
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cropButtonPressed(sender: AnyObject) {
        bottomImageView.image = topImageView.crop()
    }
    
    @IBAction func cyclePathPressed(sender: AnyObject) {
        self.topImageView.cropPath = nextPath()
    }
    
    // MARK: - Path Generation
    
    func currentPath() -> UIBezierPath {
        // Note: This is dangerous in the 'real' world. In this demo,
        //       the options list is closed and it's safe enough.
        return paths[currentPathIndex]
    }
    
    func nextPath() -> UIBezierPath {
        currentPathIndex = currentPathIndex + 1
        currentPathIndex = currentPathIndex % paths.count
        
        return currentPath()
    }
    
    func initializePaths() {
        paths.append(bigPath())
        paths.append(circlePath())
        paths.append(diamondPath())
        paths.append(verticalRectangle())
        paths.append(horizontalRectangle())
    }
    
    // MARK: Specific Paths
    
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
    
    func stripePath(startX: CGFloat) -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(startX, 980),
            CGPointMake(startX+900, 100),
            CGPointMake(startX+1000, 100),
            CGPointMake(startX+100, 980)
        ]
        
        return makePathFromPoints(points)
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: CGRectMake(660, 240, 600, 600))
    }
    
    func diamondPath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(50, 0),
            CGPointMake(100, 150),
            CGPointMake(50, 300),
            CGPointMake(0, 150)
        ]
        
        return makePathFromPoints(points)
    }
    
    func verticalRectangle() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(0, 0),
            CGPointMake(100, 0),
            CGPointMake(100, 50),
            CGPointMake(0, 50)
        ]
        
        return makePathFromPoints(points)
    }
    
    func horizontalRectangle() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPointMake(0, 0),
            CGPointMake(50, 0),
            CGPointMake(50, 100),
            CGPointMake(0, 100)
        ]
        
        return makePathFromPoints(points)
    }
    
    // MARK: - Helper Methods
    
    func makePathFromPoints(points: [CGPoint]) -> UIBezierPath {
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