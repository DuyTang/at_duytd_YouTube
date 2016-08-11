//
//  UIImageView.swift
//  YouTube
//
//  Created by Duy Tang on 8/10/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Haneke
extension UIImageView {
    func downloadImage(url: String?) {
        if let urlString = url where !urlString.isEmpty {
            if let url = NSURL(string: urlString) {
                self.hnk_setImageFromURL(url)
            } else {
                self.image = UIImage(named: AppDefine.ImageVideo)
            }
        } else {
            self.image = UIImage(named: AppDefine.ImageVideo)
        }
    }
}

