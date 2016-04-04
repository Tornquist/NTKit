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
    func numberOfTilesFor(tileView tileView: NTTileView) -> Int {
        return 5
    }

    func tileFor(tileView tileView: NTTileView, atIndexPath indexPath: NSIndexPath) -> NTTile {
        switch indexPath.item {
        case 0:
            let newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.redColor()
            newTile.tileText.text = "Centered Anchor"
            return newTile
        case 1:
            let newTile = NTTitleDetailTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.yellowColor()
            newTile.titleText.text = "Anchor 1/3"
            return newTile
        case 2:
            let newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.greenColor()
            newTile.tileText.text = "Centered Anchor"
            return newTile
        case 3: // NTImageViewTile with NTImage custom drawing
            let newTile = NTImageViewDemoTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.blueColor()
            newTile.imageView.image = NTImageExample()
            newTile.imageView.backgroundColor = UIColor.clearColor()
            newTile.titleText.text = "NTImage with NTImageEffects"
            return newTile
        case 4: // NTImageViewTile
            let newTile = NTImageViewDemoTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.purpleColor()
            newTile.imageView.image = UIImage(named: "Landscape")
            newTile.imageView.backgroundColor = UIColor.clearColor()
            return newTile
        default:
            let newTile = NTBasicTile.build(inRect: UIScreen.mainScreen().bounds)
            newTile.view.backgroundColor = UIColor.brownColor()
            newTile.tileText.text = "Centered Anchor"
            return newTile
        }
    }
    
    //MARK: - NTImage Examples
    
    func NTImageExample() -> UIImage? {
        let image = NTImage(named: "Landscape")
        guard image != nil else {
            return nil
        }
        let rectEffect = NTImageRectangleEffect(rect: CGRectMake(50, 50, 100, 100),
                                                color: UIColor.redColor())
        let shadeEffect = NTImageShadeEffect(shape: .TriangleBottomRight,
                                             color: UIColor(red: 0, green: 1, blue: 0, alpha: 0.5))
        let progressEffect = NTImageProgressCircleEffect(center: CGPointMake(image!.size.width/2, image!.size.height/2),
                                                         innerRadius: 100,
                                                         outerRadius: 200,
                                                         startAngle: 0,
                                                         endAngle: 4,
                                                         color: UIColor(red: 0, green: 1, blue: 1, alpha: 0.75),
                                                         strokeInnerCircle: true,
                                                         strokeOuterCircle: true)
        let progressEffect2 = NTImageProgressCircleEffect(center: CGPointMake(image!.size.width/2 - 500, image!.size.height/2),
                                                          radius: 200,
                                                          percent: 0.66,
                                                          color: UIColor.orangeColor(),
                                                          strokeCircle: false)
        let textEffect = NTImageTextEffect(position: CGPointMake(100, 500),
                                           text: "Hello World",
                                           fontColor: UIColor.darkGrayColor())
        let textEffect2 = NTImageTextEffect(position: CGPointMake(1500, 750),
                                            text: "Hello World",
                                            font: UIFont.systemFontOfSize(60),
                                            fontColor: UIColor.blackColor())
        image!.effects.append(rectEffect)
        image!.effects.append(shadeEffect)
        image!.effects.append(progressEffect)
        image!.effects.append(progressEffect2)
        image!.effects.append(textEffect)
        image!.effects.append(textEffect2)
        return image!.withEffects()
    }
}