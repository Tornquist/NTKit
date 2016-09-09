//
//  NTTileView.swift
//  NTKit
//
//  Created by Nathan Tornquist on 2/22/16.
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

open class NTTileView: UIView {
    /**
     NTTileView Data Source.
     
     This object will provide the data for the tile view, and
     must conform to the NTTileViewDataSource protocol.
     
     refreshTiles() will be called on the tile view after setting
     a new data source.
     */
    open var dataSource: NTTileViewDataSource? {
        didSet {
            //refreshTiles()
        }
    }
    
    /**
     NTTileView Layout.
     
     This object will provide the layouting for the tile view, and
     must conform to NTTileViewLayoutProtocol.
     
     All of the view sizes and arrangement will be set by this object.
     
     refreshTiles() will be called on the tile view after setting
     a new data source.
     */
    open var layout: NTTileViewLayoutProtocol? {
        didSet {
            //refreshTiles()
        }
    }
    
    /**
     This holds the NTTiles, the actual objects that will be shown
     */
    var tiles: [NTTile] = []
    
    /**
     Every tile is nested within a view.  These views are what is
     actually resized and arranged in the interface.  This is the
     collection of those views.
     */
    var views: [UIView] = []
    
    override init(frame: CGRect) {
		super.init(frame: frame)
        configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
        configureView()
    }
    
    func configureView() {
		self.layout = NTTileViewRowLayout(tileView: self)
		self.autoresizesSubviews = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    open func reloadTiles() {
        guard dataSource != nil else {
            NSLog("NTTileView - nil data source, cannot refresh tiles")
            return
        }
        
        let numTiles = dataSource!.numberOfTilesFor(tileView: self)
        tiles.removeAll()
        views.removeAll()
        for i in 0..<numTiles {
            let indexPath = IndexPath(item: i, section: 0)
            addTile(dataSource!.tileFor(tileView: self, atIndexPath: indexPath))
        }
        arrangeTiles()
    }
    
    open func arrangeTiles() {
        layout?.resetTileLayout()
    }
    
    func addTile(_ tile: NTTile) {
        let newView = UIView()
        self.addSubview(newView)
        newView.addSubview(tile.view)
        
        newView.autoresizesSubviews = false
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.clipsToBounds = true

        tile.parentTileView = self
        
        views.append(newView)
        tiles.append(tile)
    }
    
    /**
     Given an internal index of a specific tile, this method is used
     to focus on that tile.  The actual action performed will depend
     on the layouting engine used
     */
    open func focus(onTileWithIndex tileIndex: Int) {
        layout?.focus(onTileWithIndex: tileIndex)
    }
    
    /**
     Transition all tiles to a collapsed state, regardless of what the
     current arrangement or state is.
     */
    open func collapseAllTiles() {
        layout?.collapseAll()
    }
    
    /**
     This method will return the index of a current tile.  Depending
     on the layout engine used, the tile index may not correspond to the
     actual on-screen layout.  This is an internal index used by NTTileView
     to manage the tiles and views they are displayed within.
     
     This index can be used to perform operations (such as expand)
     on a specific tile.
     */
    open func getTileIndex(withTile tile: NTTile) -> Int? {
        for (i, t) in tiles.enumerated() {
            if t === tile {
                return i
            }
        }
        return nil
    }
    
    // MARK: - Layout Events for monitoring frame change
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layout?.updateForFrame()
    }
}
