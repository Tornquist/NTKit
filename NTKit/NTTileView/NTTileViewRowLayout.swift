//
//  NTTileViewRowLayout.swift
//  NTKit
//
//  Created by Nathan Tornquist on 2/23/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//
//  Hosted on github at github.com/Tornquist/NTKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

open class NTTileViewRowLayout: NTTileViewLayoutProtocol {

	weak open var tileView: NTTileView! 
	//MARK: - Configuration Variables
    var expandAnimationDuration: Double = 0.5
    var collapseAnimationDuration: Double = 0.5
    
    enum LayoutActions {
        case none
        case reset
        case focus
        case collapse
    }
    
    var lastAction: LayoutActions = .none
    var lastActionIndex: Int = 0
	
	public convenience init(tileView: NTTileView) {
		self.init()
		self.tileView = tileView
	}
	
    //MARK: - NTTileViewLayoutProtocol Methods
    open func resetTileLayout() {
        lastAction = .reset
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let tileHeight = viewHeight / CGFloat(tileView.tiles.count)
        
        for (index, view) in tileView.views.enumerated() {
            // Set View Position
            view.frame = CGRect(x: 0, y: CGFloat(index)*tileHeight, width: tileWidth, height: tileHeight)
            // Adjust Tile based on anchor
            let tile = tileView.tiles[index]
            position(tile, inView: view)
        }
    }
    
    open func focus(onTileWithIndex tileIndex: Int) {
        lastAction = .focus
        lastActionIndex = tileIndex
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let expandedTileHeight = viewHeight
        let collapsedTileHeight = CGFloat(0)
        
        var heightCounter: CGFloat = CGFloat(0)
        
        UIView.animate(withDuration: expandAnimationDuration, animations: {
            for (index, view) in self.tileView.views.enumerated() {
                let height = (index == tileIndex) ? expandedTileHeight : collapsedTileHeight
                
                let newFrame = CGRect(x: 0, y: heightCounter, width: tileWidth, height: height)
                view.frame = newFrame
                let tile = self.tileView.tiles[index]
                self.position(tile, inView: view)
                
                // Prepare for next tile
                heightCounter = heightCounter + height
            }
        })
    }
    
    open func collapseAll() {
        lastAction = .collapse
        
        let viewWidth = tileView.frame.width
        let viewHeight = tileView.frame.height
        
        let tileWidth = viewWidth
        let tileHeight = viewHeight / CGFloat(tileView.tiles.count)
        
        UIView.animate(withDuration: collapseAnimationDuration, animations: {
            for (index, view) in self.tileView.views.enumerated() {
                // Set View Position
                view.frame = CGRect(x: 0, y: CGFloat(index)*tileHeight, width: tileWidth, height: tileHeight)
                // Adjust Tile based on anchor
                let tile = self.tileView.tiles[index]
                self.position(tile, inView: view)
            }
        })
    }
    
    open func updateForFrame() {
        switch lastAction {
        case .reset:
            self.resetTileLayout()
        case .collapse:
            self.collapseAll()
        case .focus:
            self.focus(onTileWithIndex: lastActionIndex)
        default:
            break
        }
    }
    
    // MARK: - Helper Methods for LayoutProtocol implementation
    
    func position(_ tile: NTTile, inView view: UIView) {
        // Base Positioning
        let anchor = tile.anchorPoint()
        let viewCenter = CGPoint(x: view.frame.midX, y: view.frame.midY)
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
        newFrame = CGRect(x: newX, y: newY, width: width, height: height)
        tile.view.frame = newFrame
    }
}
