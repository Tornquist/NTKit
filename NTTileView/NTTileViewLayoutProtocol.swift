//
//  NTTileViewLayoutProtocol.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import Foundation

public protocol NTTileViewLayoutProtocol {
    /**
     Reset Tile Layout is used to relayout all the tiles
     within a given tileView.  This will collapse all focused tiles.
     */
    func resetTileLayout(tileView: NTTileView)
    
    /**
     This method will adjust the tiles to put focus
     on a specific tile specified by it's index.
     */
    func focus(tileView: NTTileView, onTileWithIndex tileIndex: Int)
}