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
                self.image = UIImage(named: "ic_video")
            }
        } else {
            self.image = UIImage(named: "ic_video")
        }
    }

    func imageFromUrlScalltoFill(urlString: String, placeHolder: UIImage?) {
        let cache = Shared.imageCache
        let imageResize = ImageResizer(size: self.bounds.size, scaleMode: .AspectFill, allowUpscaling: true, compressionQuality: 1)

        let homeFormat = Format<UIImage>(name: "home", diskCapacity: 10 * 1024 * 1024) { image in
            return imageResize.resizeImage(image)
        }
        cache.addFormat(homeFormat)

        if let imagePlaceHolder = placeHolder {
            if urlString != "" {
                self.hnk_setImageFromURL(NSURL(string: urlString)!,
                    placeholder: imagePlaceHolder,
                    format: homeFormat,
                    failure: { (error) -> () in
                    }, success: { (image) -> () in
                        UIView.transitionWithView(self, duration: 0,
                            options: UIViewAnimationOptions.TransitionCrossDissolve,
                            animations: { () -> Void in
                                self.image = image
                            }, completion: nil)
                })
            } else {
                self.image = placeHolder
            }
        }
    }
}

