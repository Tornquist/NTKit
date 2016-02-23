//
//  NTTileView.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTileView: UIView {
    public var delegate: NTTileViewDelegate?
    public var layout: NTTileViewLayoutProtocol?
    
    var tiles: [NTTile] = []
    
    public func refreshTiles() {
        guard delegate != nil else {
            NSLog("NTTileView - nil delegate, cannot refresh tiles")
            return
        }
        
        let numTiles = delegate!.numberOfTiles(self)
        tiles.removeAll()
        for i in 0..<numTiles {
            let indexPath = NSIndexPath(index: i)
            tiles.append(delegate!.tileAt(indexPath: indexPath))
        }
        layout?.layoutTiles(self)
    }
}
