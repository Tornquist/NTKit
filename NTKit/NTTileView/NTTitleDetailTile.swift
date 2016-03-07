//
//  NTTitleDetailTile.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/6/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTitleDetailTile: NTTile {
    public class func build(inRect rect: CGRect) -> NTTitleDetailTile {
        let tile = NTTitleDetailTile.init(nibName: "NTTitleDetailTile", bundle: NSBundle(forClass: self))
        tile.targetTileSize = CGSizeMake(rect.width, rect.height)
        return tile
    }
    
    @IBOutlet weak public var titleText: UILabel!
    @IBOutlet weak public var detailText: UILabel!
    
    public override func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(titleText.frame), CGRectGetMidY(titleText.frame))
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        parentTileView?.collapseAllTiles()
    }
}

