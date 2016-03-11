//
//  MemeDetailsViewController.swift
//  ImagePickerExp
//
//  Created by Sheethal Shenoy on 2/29/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topLabel?.text = meme.topText+"...."+meme.bottomText
        imageView?.image = meme.image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}

