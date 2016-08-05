//
//  BaseCollectionViewCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configInit()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }

    func configInit() {
        // setup constants data for cell
    }

    func shadow() {
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clearColor().CGColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).CGPath
    }
}
