//
//  NTTileViewLayoutProtocol.swift
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