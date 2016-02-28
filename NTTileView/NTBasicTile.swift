//
//  NTBasicTile.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTBasicTile: NTTile {
    public class func build(inRect rect: CGRect) -> NTBasicTile {
        let tile = NTBasicTile.init(nibName: "NTBasicTile", bundle: NSBundle(forClass: self))
        tile.targetTileSize = CGSizeMake(rect.width, rect.height)
        return tile
    }
    
    @IBOutlet weak var tileText: UILabel!
    
    public override func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(tileText.frame), CGRectGetMidY(tileText.frame))
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        parentTileView?.collapseAllTiles()
    }
}
