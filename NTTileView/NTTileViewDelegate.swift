//
//  NTTileViewDelegate.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import Foundation

public protocol NTTileViewDelegate {
    func numberOfTiles(tileView: NTTileView) -> Int
    func tileAt(indexPath indexPath: NSIndexPath) -> NTTile
}