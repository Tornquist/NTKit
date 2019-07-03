//
//  NTCropScrollView.swift
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

protocol NTCropScrollViewDelegate {
    func constrainScrollToRect() -> CGRect
}

class NTCropScrollView: UIScrollView, UIScrollViewDelegate {
    var _image: UIImage?
    var image: UIImage? {
        get {
            return _image
        }
        set {
            if (_image?.size != newValue?.size) {
                _image = newValue
                self.imageView.image = _image
                self.configureInitialScale()
            } else {
                _image = newValue
                self.imageView.image = _image
            }
        }
    }
    
    var enclosingView: UIView! = nil
    var enclosingViewWidthConstraint: NSLayoutConstraint! = nil
    var enclosingViewHeightConstraint: NSLayoutConstraint! = nil
    
    var imageView: UIImageView!
    var oldFrame: CGRect = CGRect.zero
    var oldConstraintRect: CGRect = CGRect.zero
    
    var defaultMinimumZoomScale: CGFloat = 0.5
    var defaultMaximumZoomScale: CGFloat = 2
    
    var cropRegionDelegate: NTCropScrollViewDelegate? = nil
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    //MARK: - Configuration
    
    func configureView() {
        // Configure Scroll View
        self.clipsToBounds = true
        self.delegate = self
        self.contentOffset = CGPoint.zero
        self.bounces = true
        self.bouncesZoom = true
        
        self.enclosingView = UIView(frame: self.frame)
        self.enclosingView.clipsToBounds = true
        self.addSubview(enclosingView)
        self.enclosingView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.enclosingView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.enclosingView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.enclosingView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.enclosingView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        self.addConstraint(topConstraint)
        self.addConstraint(bottomConstraint)
        self.addConstraint(rightConstraint)
        self.addConstraint(leftConstraint)
        
        self.enclosingViewWidthConstraint = NSLayoutConstraint(item: self.enclosingView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.enclosingViewHeightConstraint = NSLayoutConstraint(item: self.enclosingView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.enclosingView.addConstraint(enclosingViewWidthConstraint)
        self.enclosingView.addConstraint(enclosingViewHeightConstraint)
        
        // Configure Image View
        self.imageView = UIImageView()
        self.enclosingView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self.imageView!, attribute: .centerX, relatedBy: .equal, toItem: self.enclosingView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: self.imageView!, attribute: .centerY, relatedBy: .equal, toItem: self.enclosingView, attribute: .centerY, multiplier: 1, constant: 0)
        self.enclosingView.addConstraint(centerX)
        self.enclosingView.addConstraint(centerY)
        
        // Default Zoom Scaling
        self.configureInitialScale()
    }
    
    func configureInitialScale() {
        // Set Defaults
        self.minimumZoomScale = defaultMinimumZoomScale
        self.maximumZoomScale = defaultMaximumZoomScale
        self.zoomScale = 1
        
        // Configure only if image set
        guard self.image != nil else {
            return
        }
        
        // Calculate Values
        let boundingRect = constraintRect()
        let aspectRatioView = boundingRect.width/boundingRect.height
        let aspectRatioImage = self.image!.size.width/self.image!.size.height
        
        var targetScale: CGFloat = 1
        
        // Determine Scale
        if aspectRatioView < aspectRatioImage {
            targetScale = boundingRect.height/self.image!.size.height
        } else {
            targetScale = boundingRect.width/self.image!.size.width
        }
        
        // Update min/max scale
        if targetScale < self.minimumZoomScale {
            self.minimumZoomScale = targetScale
        } else if targetScale > self.maximumZoomScale {
            self.maximumZoomScale = targetScale
        }
        
        // Set Scale
        self.zoomScale = targetScale
        
        // Update Constraints
        self.updateImageConstraints()
    }
    
    func updateImageConstraints() {
        guard self.image != nil else {
            return
        }
        
        // Calculate New View Size
        let boundingRect = constraintRect()
        let horizontalExcess = (self.frame.width - boundingRect.width)
        let verticalExcess = (self.frame.height - boundingRect.height)
        
        let enclosingViewWidth = self.image!.size.width*zoomScale + horizontalExcess
        let enclosingViewHeight = self.image!.size.height*zoomScale + verticalExcess
        
        // Update Internal Views
        self.enclosingViewWidthConstraint.constant = enclosingViewWidth
        self.enclosingViewHeightConstraint.constant = enclosingViewHeight
        self.enclosingView.setNeedsLayout()
        self.imageView.setNeedsLayout()
        self.layoutIfNeeded()
        
        // Update Scroll View
        self.contentSize = CGSize(width: enclosingViewWidth, height: enclosingViewHeight)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let conRect = constraintRect()
        if self.oldFrame != self.frame || self.oldConstraintRect != conRect {
            self.oldConstraintRect = conRect
            self.oldFrame = self.frame
            self.configureInitialScale()
        }
    }
    
    func constraintRect() -> CGRect {
        var rect: CGRect! = cropRegionDelegate?.constrainScrollToRect()
        if rect == nil {
            rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        return rect
    }
    
    //MARK: - UIScrollView Delegates
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageConstraints()
    }
}
