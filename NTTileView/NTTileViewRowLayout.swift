//
//  NTTileViewRowLayout.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

class NTTileViewRowLayout: NTTileViewLayoutProtocol {
    func resetTileLayout(tileView: NTTileView) {
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let tileHeight = viewHeight / CGFloat(tileView.tiles.count)
        
        for (index, view) in tileView.views.enumerate() {
            // Set View Position
            view.frame = CGRectMake(0, CGFloat(index)*tileHeight, tileWidth, tileHeight)
            // Set Tile Position
            tileView.tiles[index].view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            // Adjust Tile based on anchor
            NSLog("")
            NSLog("view frame: \(view.frame)")
            NSLog("Tile Frame: \(tileView.tiles[index].view.frame)")
            NSLog("origin: \(tileView.tiles[index].view.frame.origin)")
        }
        tileView.setNeedsDisplay()
        NSLog("Tile View Size: \(tileView.frame)")
        NSLog("Tile View Origin: \(tileView.frame.origin)")
    }
    
    func focus(tileView: NTTileView, onTileWithIndex tileIndex: Int) {
        // Do nothing
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let expandedTileWidth = viewWidth
        let expandedTileHeight = viewHeight
        
        let collapsedTileWidth = CGFloat(0)
        let collapsedTileHeight = CGFloat(0)
        
        for (index, view) in tileView.views.enumerate() {
            if (index == tileIndex) {
                view.frame = CGRectMake(0, 0, expandedTileWidth, expandedTileHeight)
            } else {
                view.frame = CGRectMake(0, 0, collapsedTileWidth, collapsedTileHeight)
            }
            tileView.tiles[index].view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        }
    }
    
    func collapseAll(tileView: NTTileView) {
        // TODO: Actually collapse tiles instead of just resetting the arrangement
        resetTileLayout(tileView)
    }
}