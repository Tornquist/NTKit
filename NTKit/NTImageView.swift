//
//  NTImageView.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTImageView: UIScrollView, UIScrollViewDelegate {
    var _image: UIImage?
    public var image: UIImage? {
        get {
            return _image
        }
        set {
            _image = newValue
            self.imageView.image = _image
            self.setFrameFromImage()
            self.configureInitialZoom()
        }
    }
    
    var imageView: UIImageView!
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
    public convenience init() {
        self.init()
        self.configureView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    func configureView() {
        // Configure Scroll View
        self.clipsToBounds = true
        self.delegate = self
        self.contentOffset = CGPointZero
        
        // Configure Image View
        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.topConstraint = NSLayoutConstraint(item: self.imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        self.leftConstraint = NSLayoutConstraint(item: self.imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
        self.bottomConstraint = NSLayoutConstraint(item: self.imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        self.rightConstraint = NSLayoutConstraint(item: self.imageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        self.addConstraint(topConstraint)
        self.addConstraint(bottomConstraint)
        self.addConstraint(rightConstraint)
        self.addConstraint(leftConstraint)
        
        // Default Zoom Scaling
        self.configureInitialZoom()
    }
    
    func configureInitialZoom() {
        // Set Defaults
        self.minimumZoomScale = 0.5
        self.maximumZoomScale = 2
        self.zoomScale = 1
        
        // Configure only if image set
        guard self.image != nil else {
            return
        }
        
        // Calculate Values
        let aspectRatioView = self.frame.width/self.frame.height
        let aspectRatioImage = self.image!.size.width/self.image!.size.height
        
        var targetScale: CGFloat = 1
        
        // Determine Scale
        if aspectRatioView > aspectRatioImage {
            targetScale = self.frame.height/self.image!.size.height
        } else {
            targetScale = self.frame.width/self.image!.size.width
        }
        
        // Update min/max scale
        if targetScale > self.minimumZoomScale {
            self.minimumZoomScale = targetScale
        } else if targetScale > self.maximumZoomScale {
            self.maximumZoomScale = targetScale
        }
        
        // Set Scale
        self.zoomScale = targetScale
        
        // Update Constraints
        self.refreshLayout()
    }
    
    func refreshLayout() {
        guard self.image != nil else {
            return
        }
        // Update Padding
        let horizontalPadding = max(0, (self.frame.width - self.image!.size.width * self.zoomScale)/2)
        let verticalPadding = max(0, (self.frame.height - self.image!.size.height * self.zoomScale)/2)
        
        self.topConstraint.constant = verticalPadding
        self.bottomConstraint.constant = verticalPadding
        self.leftConstraint.constant = horizontalPadding
        self.rightConstraint.constant = horizontalPadding
        self.layoutIfNeeded()
    }
    
    func setFrameFromImage() {
        guard self.image != nil else {
            return
        }
        let newFrame = CGRectMake(0, 0, self.image!.size.width, self.image!.size.height)
        self.imageView.frame = newFrame
    }
    
    //MARK: - UIScrollView Delegates
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        refreshLayout()
    }
}
