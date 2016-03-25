//
//  NTTileViewRowLayout.swift
//  NTKit
//
//  Created by Nathan Tornquist on 2/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTileViewRowLayout: NTTileViewLayoutProtocol {

	weak public var tileView: NTTileView! 
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
	
	public convenience init(tileView: NTTileView) {
		self.init()
		self.tileView = tileView
	}
	
    //MARK: - NTTileViewLayoutProtocol Methods
    public func resetTileLayout() {
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
            position(tile, inView: view)
        }
    }
    
    public func focus(onTileWithIndex tileIndex: Int) {
        lastAction = .Focus
        lastActionIndex = tileIndex
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let expandedTileHeight = viewHeight
        let collapsedTileHeight = CGFloat(0)
        
        var heightCounter: CGFloat = CGFloat(0)
        
        UIView.animateWithDuration(expandAnimationDuration, animations: {
            for (index, view) in self.tileView.views.enumerate() {
                let height = (index == tileIndex) ? expandedTileHeight : collapsedTileHeight
                
                let newFrame = CGRectMake(0, heightCounter, tileWidth, height)
                view.frame = newFrame
                let tile = self.tileView.tiles[index]
                self.position(tile, inView: view)
                
                // Prepare for next tile
                heightCounter = heightCounter + height
            }
        })
    }
    
    public func collapseAll() {
        lastAction = .Collapse
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let tileHeight = viewHeight / CGFloat(tileView.tiles.count)
        
        UIView.animateWithDuration(collapseAnimationDuration, animations: {
            for (index, view) in self.tileView.views.enumerate() {
                // Set View Position
                view.frame = CGRectMake(0, CGFloat(index)*tileHeight, tileWidth, tileHeight)
                // Adjust Tile based on anchor
                let tile = self.tileView.tiles[index]
                self.position(tile, inView: view)
            }
        })
    }
    
    public func updateForFrame() {
        switch lastAction {
        case .Reset:
            self.resetTileLayout()
        case .Collapse:
            self.collapseAll()
        case .Focus:
            self.focus(onTileWithIndex: lastActionIndex)
        default:
            break
        }
    }
    
    // MARK: - Helper Methods for LayoutProtocol implementation
    
    func position(tile: NTTile, inView view: UIView) {
        // Base Positioning
        let anchor = tile.anchorPoint()
        let viewCenter = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        var newX = viewCenter.x - anchor.x - view.frame.origin.x
        var newY = viewCenter.y - anchor.y - view.frame.origin.y
        let width = (tileView.frame.width > view.frame.width) ? tileView.frame.width : view.frame.width
        let height = (tileView.frame.height > view.frame.height) ? tileView.frame.height : view.frame.height
        
        // Apply Corrections
        if (newX > 0) { newX = 0 }
        if (newX + width < view.frame.width) { newX = view.frame.width - width }
        
        if (newY > 0) { newY = 0 }
        if (newY + height < view.frame.height) { newY = view.frame.height - height }
        
        // Set New Frame
        var newFrame: CGRect!
        newFrame = CGRectMake(newX, newY, width, height)
        tile.view.frame = newFrame
    }
}