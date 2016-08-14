//
//  BaseTableViewCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configInit()
        self.setUpUI()
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    // MARK:- Set Up
    func configInit() {
        // setup constants data for cell
    }
    func setUpUI() {

    }
}
