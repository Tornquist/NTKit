//
//  ViewController.swift
//  NTTileViewDemo
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit
import NTTileView

class ViewController: UIViewController, NTTileViewDelegate {

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
        tileView.delegate = self
        tileView.refreshTiles()
    }
    
    // MARK: - Tile View Delegate Methods
    func numberOfTiles(tileView: NTTileView) -> Int {
        return 5
    }

    func tileAt(indexPath indexPath: NSIndexPath) -> NTTile {
        return NTTile()
    }
}

