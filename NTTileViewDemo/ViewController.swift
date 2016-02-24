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
    }
    
    override func viewDidAppear(animated: Bool) {
        tileView.arrangeTiles()
    }
    
    // MARK: - Tile View Data Source Methods
    func numberOfTiles(tileView: NTTileView) -> Int {
        return 5
    }

    func tileAt(indexPath indexPath: NSIndexPath) -> NTTile {
        let newTile = NTTile()
        newTile.frame = CGRectMake(0, 0, tileView.frame.width, tileView.frame.height)
        
        switch indexPath.item {
        case 0:
            newTile.backgroundColor = UIColor.redColor()
        case 1:
            newTile.backgroundColor = UIColor.yellowColor()
        case 2:
            newTile.backgroundColor = UIColor.greenColor()
        case 3:
            newTile.backgroundColor = UIColor.blueColor()
        case 4:
            newTile.backgroundColor = UIColor.purpleColor()
        default:
            newTile.backgroundColor = UIColor.brownColor()
        }
        
        return newTile
    }
}