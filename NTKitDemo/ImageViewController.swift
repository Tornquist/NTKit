//
//  ImageViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 5/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit
import NTKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: NTImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "Landscape")
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}