//
//  NTTile.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTile: UIView {
    public var parentTileView: NTTileView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureTile()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTile()
    }
    
    func configureTile() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // TODO: Check to make sure single touch started and ended in visible part of tile
        if let tileIndex = parentTileView?.getTileIndex(withTile: self) {
            parentTileView?.focus(onTileWithIndex: tileIndex)
        }
    }
}