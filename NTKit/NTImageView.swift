//
//  NTImageView.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTImageView: UIScrollView {
    var _image: UIImage?
    public var image: UIImage? {
        get {
            return _image
        }
        set {
            _image = newValue
            self.imageView.image = _image
            self.refreshLayout()
        }
    }
    
    var imageView: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    func configureView() {
        self.clipsToBounds = true
        self.imageView = UIImageView(frame: self.frame)
        self.addSubview(self.imageView)
        self.refreshLayout()
    }
    
    func refreshLayout() {
        self.imageView.frame = self.frame
    }
}
