//
//  NTTile.swift
//  NTKit
//
//  Created by Nathan Tornquist on 2/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTile: UIViewController {
    var parentTileView: NTTileView?
    var targetTileSize: CGSize?
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let tileIndex = parentTileView?.getTileIndex(withTile: self) {
            parentTileView?.focus(onTileWithIndex: tileIndex)
        }
    }
}