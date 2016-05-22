//
//  MainViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 5/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let demoTitles: [String] = [
        "NTTileView",
        "NTImageView",
        "NTImage with NTImageEffects"
    ]
    
    // MARK: - Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("demoCell")!
        cell.textLabel?.text = demoTitles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tileView")
            self.presentViewController(newVC, animated: true, completion: nil)
        case 1:
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("imageView")
            self.presentViewController(newVC, animated: true, completion: nil)
        case 2:
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("imageViewEffects")
            self.presentViewController(newVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "NTKit Demos"
    }
}