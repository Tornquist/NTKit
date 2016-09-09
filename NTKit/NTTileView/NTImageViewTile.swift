//
//  NTImageViewTile.swift
//  NTKit
//
//  Created by Nathan Tornquist on 3/6/16.
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

open class NTImageViewTile: NTTile {
    open class func build(inRect rect: CGRect) -> NTImageViewTile {
        let tile = NTImageViewTile.init(nibName: "NTImageViewTile", bundle: Bundle(for: self))
        tile.targetTileSize = CGSize(width: rect.width, height: rect.height)
        return tile
    }
    
    @IBOutlet weak open var titleText: UILabel!
    @IBOutlet weak open var imageView: UIImageView!
    
    open override func anchorPoint() -> CGPoint {
        return CGPoint(x: titleText.frame.midX, y: titleText.frame.midY)
    }
    
    @IBAction func closePressed(_ sender: AnyObject) {
        parentTileView?.collapseAllTiles()
    }
}

