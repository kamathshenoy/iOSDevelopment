//
//  MemeData.swift
//  ImagePickerExp
//
//  Created by Sheethal Shenoy on 2/28/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit

let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -2.0
]

struct Meme {
    var topText: String
    var bottomText:String
    var image :UIImage
    var memedImage :UIImage
}
