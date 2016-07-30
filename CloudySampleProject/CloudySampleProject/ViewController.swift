//
//  ViewController.swift
//  CloudySampleProject
//
//  Created by Bobo on 7/29/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topCloudyView: CloudyView!
    @IBOutlet weak var bottomCloudyView: CloudyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomCloudyView.orientation = .Up
        bottomCloudyView.cloudsShadowOffset = CGSize(width: 0.0, height: -1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func handleTapReloadButton(sender: AnyObject) {
        topCloudyView.reload()
        bottomCloudyView.reload()
    }

}

