//
//  NTTileViewLayoutProtocol.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import Foundation

public protocol NTTileViewLayoutProtocol {

	weak var tileView: NTTileView! { get set }
	
	/**
     Reset Tile Layout is used to relayout all the tiles
     within a given tileView.  This will collapse all focused tiles.
     */
    func resetTileLayout()
    
    /**
     This method will adjust the tiles to put focus
     on a specific tile specified by it's index.
     */
    func focus(onTileWithIndex tileIndex: Int)
    
    /**
     Transition all tiles to a collapsed state
     */
    func collapseAll()
    
    /**
     Reapply the most recent layout based on the new frame
     */
    func updateForFrame()
}