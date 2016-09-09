//
//  NTCropView.swift
//  NTKit
//
//  Created by Nathan Tornquist on 5/25/16.
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

open class NTCropView: UIView, NTCropScrollViewDelegate {
    var scrollView: NTCropScrollView! = nil
    var overlayView: NTCropOverlayView! = nil
    
    /**
     Image
     
     The image to be cropped.  The size and shape do not matter,
     the image will be cropped using a scaled cropPath.
     */
    open var image: UIImage? {
        get {
            return scrollView.image
        }
        set {
            scrollView.image = newValue
        }
    }
    
    /**
     Crop Path
     
     The bezier path describing the pattern to be cropped from the image.
     The size and origin of this path will be ignored, and the path will
     be scaled (with aspect ratio maintained) to crop whatever image is
     passed in.
     */
    open var cropPath: UIBezierPath? {
        get {
            return overlayView.cropPath
        }
        set {
            overlayView.cropPath = newValue
            scrollView.configureInitialScale()
        }
    }
    
    /**
     exclusedRegionOverlayColor
     
     The color to fill the entire region excluded when crop() is executed.
     This color will fill the entire view, not only the section over the image.
     
     This color defaults to black with 80% opacity.
     */
    open var exclusedRegionOverlayColor: UIColor {
        get {
            return overlayView.shadeColor
        }
        set {
            overlayView.shadeColor = newValue
        }
    }
    
    /**
     croppedRegionOverlayColor
     
     The color to fill the region returned when crop() is executed.
     
     This color defaults to clear.
     */
    open var croppedRegionOverlayColor: UIColor {
        get {
            return overlayView.cropPathColor
        }
        set {
            overlayView.cropPathColor = newValue
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addScrollView()
        self.addOverlayView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addScrollView()
        self.addOverlayView()
    }
    
    // MARK: - Crop Image
    
    /**
     crop
     
     The current cropPath will be applied to the current image.
     If both are set, the result will be a segment of the original image
     that represents the outline and aspect ratio of the provided
     crop path.
     */
    open func crop() -> UIImage? {
        if let currentImage = image, let cropFrame = overlayView.cropRect, let path = cropPath {
            let frameInImage = self.scrollView.imageView.convert(cropFrame, from: self.overlayView)
            
            // Map path to image
            let scaleFactor = frameInImage.width/path.bounds.width
            let point = CGPoint(x: frameInImage.minX, y: frameInImage.minY)
            let scaledPath = NTCropHelper.scale(path, toPoint: point, withScale: scaleFactor)
            
            // Mask original image
            UIGraphicsBeginImageContextWithOptions(currentImage.size, false, 0)
            scaledPath.addClip()
            currentImage.draw(at: CGPoint.zero)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Crop masked image to size (visible at min and max positions, no extra whitespace)
            let boundingBox = scaledPath.bounds
            UIGraphicsBeginImageContext(boundingBox.size)
            newImage?.draw(at: CGPoint(x: -boundingBox.minX, y: -boundingBox.minY))
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return croppedImage
        }
        return nil
    }
    
    // MARK: - View Configuration
    
    func addScrollView() {
        scrollView = NTCropScrollView(frame: self.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizesSubviews = true
        scrollView.cropRegionDelegate = self
        self.addSubview(scrollView)
        let topConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        self.addConstraint(topConstraint)
        self.addConstraint(bottomConstraint)
        self.addConstraint(leftConstraint)
        self.addConstraint(rightConstraint)
    }
    
    func addOverlayView() {
        overlayView = NTCropOverlayView(frame: self.frame)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.autoresizesSubviews = true
        self.addSubview(overlayView)
        let topConstraint = NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: overlayView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: overlayView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        self.addConstraint(topConstraint)
        self.addConstraint(bottomConstraint)
        self.addConstraint(leftConstraint)
        self.addConstraint(rightConstraint)
    }
    
    // MARK: - NTCropScrollViewDelegate Methods
    
    func constrainScrollToRect() -> CGRect {
        if let cropFrame = overlayView.cropRect {
            return cropFrame
        }
        return CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
}
