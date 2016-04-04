//
//  NTImageViewDemoTile.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 3/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit
import NTKit

public class NTImageViewDemoTile: NTTile {
    
    @IBOutlet public var titleText: UILabel!
    @IBOutlet public var imageView: NTImageView!
    
    public class func build(inRect rect: CGRect) -> NTImageViewDemoTile {
        let tile = NTImageViewDemoTile.init(nibName: "NTImageViewDemoTile", bundle: NSBundle(forClass: self))
        tile.targetTileSize = CGSizeMake(rect.width, rect.height)
        return tile
    }
    
    public override func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(titleText.frame), CGRectGetMidY(titleText.frame))
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        parentTileView?.collapseAllTiles()
    }
}

