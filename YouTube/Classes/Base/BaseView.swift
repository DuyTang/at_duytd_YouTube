//
//  BaseView.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class BaseView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpData()
        self.setUpUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpData()
        self.setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setUpUI() {
    }

    func setUpData() {
    }
}
