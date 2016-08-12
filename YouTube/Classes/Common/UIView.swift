//
//  UIView.swift
//  YouTube
//
//  Created by Duy Tang on 8/9/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

extension UIView {
    func setBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: Int) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.init(hex: borderColor).CGColor
    }
}
