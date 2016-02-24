//
//  NTTile.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTile: UIView {
    public func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    }
}