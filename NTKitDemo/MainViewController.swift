//
//  MainViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 5/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct Demo {
        var title: String
        var storyboardViewName: String
    }
    
    let demos: [Demo] = [
        Demo(title: "NTTileView", storyboardViewName: "tileView"),
        Demo(title: "NTImageView", storyboardViewName: "imageView"),
        Demo(title: "NTImage with NTImageEffects", storyboardViewName: "imageViewEffects"),
        Demo(title: "NTCrop", storyboardViewName: "cropView")
    ]
    
    // MARK: - Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("demoCell")!
        cell.textLabel?.text = demos[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let demo = demos[indexPath.row]
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(demo.storyboardViewName)
        self.presentViewController(newVC, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "NTKit Demos"
    }
}