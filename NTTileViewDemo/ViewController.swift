//
//  ViewController.swift
//  NTTileViewDemo
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit
import NTTileView

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
        let newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
        
        switch indexPath.item {
        case 0:
            newTile.view.backgroundColor = UIColor.redColor()
        case 1:
            newTile.view.backgroundColor = UIColor.yellowColor()
        case 2:
            newTile.view.backgroundColor = UIColor.greenColor()
        case 3:
            newTile.view.backgroundColor = UIColor.blueColor()
        case 4:
            newTile.view.backgroundColor = UIColor.purpleColor()
        default:
            newTile.view.backgroundColor = UIColor.brownColor()
        }
        
        return newTile
    }
}