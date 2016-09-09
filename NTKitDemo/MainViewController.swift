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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell")!
        cell.textLabel?.text = demos[(indexPath as NSIndexPath).row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = demos[(indexPath as NSIndexPath).row]
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: demo.storyboardViewName)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "NTKit Demos"
    }
}
