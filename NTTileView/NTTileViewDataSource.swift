//
//  NTTileViewDataSource.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import Foundation

public protocol NTTileViewDataSource {
    /**
     Returns the integer number of tiles that the provided
     NTTileView should display
     */
    func numberOfTiles(tileView: NTTileView) -> Int
    
    /**
     Returns the NTTile for a given index.
     */
    func tileAt(indexPath indexPath: NSIndexPath) -> NTTile
}