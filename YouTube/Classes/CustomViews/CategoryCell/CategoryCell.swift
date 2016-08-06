//
//  CategoryCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var nameCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    func changFont(isSelected: Bool) {
        if isSelected {
            nameCategoryLabel.font = UIFont(name: "Neutra Text TF", size: 19)
        } else {
            nameCategoryLabel.font = UIFont(name: "Neutra Text", size: 19)
        }
    }

    func configureCategoryCell() {
        self.nameCategoryLabel.text = "Category"
    }

    private func setUpUI() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }

}
