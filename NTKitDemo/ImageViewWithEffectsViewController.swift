//
//  ImageViewWithEffectsViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 5/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit
import NTKit

class ImageViewWithEffectsViewController: UIViewController {
    
    @IBOutlet weak var imageView: NTImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = NTImageExample()
    }    
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        let textEffect = NTImageTextEffect(anchor: CGPointMake(100, 500),
                                           text: "Hello World",
                                           fontColor: UIColor.darkGrayColor())
        let textEffect2 = NTImageTextEffect(anchor: CGPointMake(image!.size.width/2, image!.size.height/2),
                                            anchorPosition: .Center,
                                            text: "This is a test of\nmultiline right\naligned text.",
                                            textAlignment: .Right,
                                            font: UIFont.systemFontOfSize(60),
                                            fontColor: UIColor.blackColor())
        let textEffect3 = NTImageBlockTextEffect(anchor: CGPointMake(image!.size.width, image!.size.height),
                                                 anchorPosition: .BottomRight,
                                                 maxWidth: 500,
                                                 text: "This will be a\ncomplicated string with multiple different\nlengths of lines.",
                                                 baseFont: UIFont.systemFontOfSize(60),
                                                 fontColor: UIColor.blackColor(),
                                                 capitalize: true,
                                                 trailingTargetCharacterThreshold: 100)
        let textEffect4 = NTImageBlockTextEffect(anchor: CGPointMake(image!.size.width, 0),
                                                 anchorPosition: .TopRight,
                                                 maxWidth: 1000,
                                                 text: "This will be a complicated string with multiple different lengths of lines.  As you type, more lines are added.",
                                                 baseFont: UIFont.systemFontOfSize(60),
                                                 fontColor: UIColor.blackColor(),
                                                 capitalize: true)
        image!.effects.append(rectEffect)
        image!.effects.append(shadeEffect)
        image!.effects.append(progressEffect)
        image!.effects.append(progressEffect2)
        image!.effects.append(textEffect)
        image!.effects.append(textEffect2)
        image!.effects.append(textEffect3)
        image!.effects.append(textEffect4)
        return image!.withEffects()
    }

}