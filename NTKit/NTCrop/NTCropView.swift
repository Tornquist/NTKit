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

public class NTCropView: UIView {
    var scrollView: NTCropScrollView! = nil
    var overlayView: NTCropOverlayView! = nil
    
    public var image: UIImage? {
        get {
            if scrollView != nil {
                return scrollView.image
            }
            return nil
        }
        set {
            if scrollView != nil {
                scrollView.image = newValue
            }
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
    
    // MARK: - View Configuration
    
    func addScrollView() {
        scrollView = NTCropScrollView(frame: self.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizesSubviews = true
        self.addSubview(scrollView)
        let topConstraint = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
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
        let widthConstraint = NSLayoutConstraint(item: overlayView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.5, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: overlayView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.5, constant: 0)
        let centerVerticalConstraint = NSLayoutConstraint(item: overlayView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        let centerHorizontalConstraint = NSLayoutConstraint(item: overlayView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        self.addConstraint(widthConstraint)
        self.addConstraint(heightConstraint)
        self.addConstraint(centerVerticalConstraint)
        self.addConstraint(centerHorizontalConstraint)
    }
}