//
//  NTImage.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTImage: UIImage {
    public var effects: [NTImageEffect] = []
    
    public convenience init?(named name: String) {
        guard let image = UIImage(named: name) where nil != image.CGImage else {
            return nil
        }
        self.init(CGImage: image.CGImage!)
    }
    
    public func withEffects() -> UIImage {
        var modifiedImage = self as UIImage
        for effect in effects {
            modifiedImage = effect.apply(onImage: modifiedImage)
        }
        return modifiedImage
    }
}
