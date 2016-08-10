//
//  UIView.swift
//  YouTube
//
//  Created by Duy Tang on 8/9/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

extension UIView {
    class func setBorder(view: UIView, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: Int) {
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = UIColor.init(hex: borderColor).CGColor
    }
}
