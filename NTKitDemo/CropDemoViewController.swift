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
    
    @IBAction func closePressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cropButtonPressed(_ sender: AnyObject) {
        bottomImageView.image = topImageView.crop()
    }
    
    @IBAction func cyclePathPressed(_ sender: AnyObject) {
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
        paths.append(verticalRectanglePath())
        paths.append(horizontalRectanglePath())
        paths.append(trianglePath())
        paths.append(triforcePath())
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
            resultPath.append(path)
        }
        
        return resultPath
    }
    
    func stripePath(_ startX: CGFloat) -> UIBezierPath {
        let points: [CGPoint] = [
            CGPoint(x: startX, y: 980),
            CGPoint(x: startX+900, y: 100),
            CGPoint(x: startX+1000, y: 100),
            CGPoint(x: startX+100, y: 980)
        ]
        
        return makePathFromPoints(points)
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: 660, y: 240, width: 600, height: 600))
    }
    
    func diamondPath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPoint(x: 50, y: 0),
            CGPoint(x: 100, y: 150),
            CGPoint(x: 50, y: 300),
            CGPoint(x: 0, y: 150)
        ]
        
        return makePathFromPoints(points)
    }
    
    func verticalRectanglePath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 100, y: 0),
            CGPoint(x: 100, y: 50),
            CGPoint(x: 0, y: 50)
        ]
        
        return makePathFromPoints(points)
    }
    
    func horizontalRectanglePath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 50, y: 0),
            CGPoint(x: 50, y: 100),
            CGPoint(x: 0, y: 100)
        ]
        
        return makePathFromPoints(points)
    }
    
    func trianglePath() -> UIBezierPath {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 3),
            CGPoint(x: 4, y: 3),
            CGPoint(x: 2, y: 0)
        ]
        
        return makePathFromPoints(points)
    }
    
    func triforcePath() -> UIBezierPath {
        var paths: [UIBezierPath] = []

        //         f
        //      d    e
        //    a    b   c
        
        let triangleHeight: CGFloat = 0.866
        let triangleSideLength: CGFloat = 1
        
        let pointA = CGPoint(x: 0, y: triangleHeight*2)
        let pointB = CGPoint(x: triangleSideLength, y: triangleHeight*2)
        let pointC = CGPoint(x: triangleSideLength*2, y: triangleHeight*2)
        let pointD = CGPoint(x: triangleSideLength/2, y: triangleHeight)
        let pointE = CGPoint(x: triangleSideLength*1.5, y: triangleHeight)
        let pointF = CGPoint(x: triangleSideLength, y: 0)
        
        let points1: [CGPoint] = [
            pointA, pointB, pointD
        ]
        paths.append(makePathFromPoints(points1))
        
        let points2: [CGPoint] = [
            pointB, pointC, pointE
        ]
        paths.append(makePathFromPoints(points2))
        
        let points3: [CGPoint] = [
            pointD, pointE, pointF
        ]
        paths.append(makePathFromPoints(points3))
        
        let resultPath = UIBezierPath()
        for path in paths {
            resultPath.append(path)
        }
        
        return resultPath
    }
    
    // MARK: - Helper Methods
    
    func makePathFromPoints(_ points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        return path
    }
}
