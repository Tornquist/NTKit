//
//  ViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit
import NTKit

class ViewController: UIViewController, NTTileViewDataSource {

    @IBOutlet weak var tileView: NTTileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTileView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTileView() {
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tileView]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["tileView":tileView])
        let horizontalConstrints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tileView]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["tileView":tileView])
        self.view.addConstraints(verticalConstraints)
        self.view.addConstraints(horizontalConstrints)
        tileView.dataSource = self
        tileView.reloadTiles()
    }
    
    override func viewDidAppear(animated: Bool) {
        tileView.arrangeTiles()
    }
    
    // MARK: - Tile View Data Source Methods
    func numberOfTiles(tileView: NTTileView) -> Int {
        return 5
    }

    func tileAt(indexPath indexPath: NSIndexPath) -> NTTile {
        var newTile: NTTile!
        
        switch indexPath.item {
        case 0:
            newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.redColor()
            (newTile as! NTBasicTile).tileText.text = "Centered Anchor"
            
        case 1:
            newTile = NTTitleDetailTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.yellowColor()
            (newTile as! NTTitleDetailTile).titleText.text = "Anchor 1/3"
            
        case 2:
            newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.greenColor()
            (newTile as! NTBasicTile).tileText.text = "Centered Anchor"
            
        case 3:
            newTile = NTImageViewTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.blueColor()
            (newTile as! NTImageViewTile).titleText.text = "Anchor on Bottom"
            
        case 4:
            newTile = NTImageViewDemoTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.purpleColor()
            
        default:
            newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.brownColor()
            (newTile as! NTBasicTile).tileText.text = "Centered Anchor"
        }
        
        return newTile
    }
}