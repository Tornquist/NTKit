//
//  NTTileViewRowLayout.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

class NTTileViewRowLayout: NTTileViewLayoutProtocol {
    //MARK: - Configuration Variables
    var expandAnimationDuration: Double = 0.5
    var collapseAnimationDuration: Double = 0.5
    
    enum LayoutActions {
        case None
        case Reset
        case Focus
        case Collapse
    }
    
    var lastAction: LayoutActions = .None
    var lastActionIndex: Int = 0
    
    //MARK: - NTTileViewLayoutProtocol Methods
    func resetTileLayout(tileView: NTTileView) {
        lastAction = .Reset
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let tileHeight = viewHeight / CGFloat(tileView.tiles.count)
        
        for (index, view) in tileView.views.enumerate() {
            // Set View Position
            view.frame = CGRectMake(0, CGFloat(index)*tileHeight, tileWidth, tileHeight)
            // Adjust Tile based on anchor
            let tile = tileView.tiles[index]
            position(tileView: tileView, tile: tile, inView: view)
        }
    }
    
    func focus(tileView: NTTileView, onTileWithIndex tileIndex: Int) {
        lastAction = .Focus
        lastActionIndex = tileIndex
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let expandedTileHeight = viewHeight
        let collapsedTileHeight = CGFloat(0)
        
        var heightCounter: CGFloat = CGFloat(0)
        
        UIView.animateWithDuration(expandAnimationDuration, animations: {
            for (index, view) in tileView.views.enumerate() {
                let height = (index == tileIndex) ? expandedTileHeight : collapsedTileHeight
                
                let newFrame = CGRectMake(0, heightCounter, tileWidth, height)
                view.frame = newFrame
                let tile = tileView.tiles[index]
                self.position(tileView: tileView, tile: tile, inView: view)
                
                // Prepare for next tile
                heightCounter = heightCounter + height
            }
        })
    }
    
    func collapseAll(tileView: NTTileView) {
        lastAction = .Collapse
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let tileHeight = viewHeight / CGFloat(tileView.tiles.count)
        
        UIView.animateWithDuration(collapseAnimationDuration, animations: {
            for (index, view) in tileView.views.enumerate() {
                // Set View Position
                view.frame = CGRectMake(0, CGFloat(index)*tileHeight, tileWidth, tileHeight)
                // Adjust Tile based on anchor
                let tile = tileView.tiles[index]
                self.position(tileView: tileView, tile: tile, inView: view)
            }
        })
    }
    
    func updateForFrame(tileView: NTTileView) {
        switch lastAction {
        case .Reset:
            self.resetTileLayout(tileView)
        case .Collapse:
            self.collapseAll(tileView)
        case .Focus:
            self.focus(tileView, onTileWithIndex: lastActionIndex)
        default:
            break
        }
    }
    
    // MARK: - Helper Methods for LayoutProtocol implementation
    
    func position(tileView tileView: NTTileView, tile: NTTile, inView view: UIView) {
        let anchor = tile.anchorPoint()
        let viewCenter = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        let newX = viewCenter.x - anchor.x - view.frame.origin.x
        let newY = viewCenter.y - anchor.y - view.frame.origin.y
        var newFrame: CGRect!
        newFrame = CGRectMake(newX, newY, tileView.frame.width, tileView.frame.height)
        tile.view.frame = newFrame
    }
}