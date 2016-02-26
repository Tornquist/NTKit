//
//  NTTile
//  NTTileView
//
//  Created by Nathan Tornquist on 2/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTile: UIViewController {
    var parentTileView: NTTileView?
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func anchorPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // TODO: Check to make sure single touch started and ended in visible part of tile
        if let tileIndex = parentTileView?.getTileIndex(withTile: self) {
            parentTileView?.focus(onTileWithIndex: tileIndex)
        }
    }
}