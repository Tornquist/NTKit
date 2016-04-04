//
//  NTImageViewDemoTile.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 3/23/16.
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
import NTKit

public class NTImageViewDemoTile: NTTile {
    
    @IBOutlet public var titleText: UILabel!
    @IBOutlet public var imageView: NTImageView!
    
    public class func build(inRect rect: CGRect) -> NTImageViewDemoTile {
        let tile = NTImageViewDemoTile.init(nibName: "NTImageViewDemoTile", bundle: NSBundle(forClass: self))
        tile.targetTileSize = CGSizeMake(rect.width, rect.height)
        return tile
    }
    
    public override func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(titleText.frame), CGRectGetMidY(titleText.frame))
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        parentTileView?.collapseAllTiles()
    }
}

