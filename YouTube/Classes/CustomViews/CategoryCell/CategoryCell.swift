//
//  CategoryCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class CategoryCell: BaseCollectionViewCell {

    @IBOutlet weak private var nameCategoryLabel: UILabel!
    struct Options {
        static let FontSize: CGFloat = 19
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    // MARK:- Action
    func changFont(isSelected: Bool) {
        if isSelected {
            nameCategoryLabel.font = UIFont().fontNeutraTF(Options.FontSize)
            nameCategoryLabel.textColor = Color.BorderColor
        } else {
            nameCategoryLabel.font = UIFont().fontNeutra(Options.FontSize)
            nameCategoryLabel.textColor = Color.CategoryTextColor
        }
    }

    // MARK:- Configure Cell
    func configureCategoryCell(category: Category) {
        nameCategoryLabel.text = category.title
    }
    // MARK:- Set Up UI
    private func setUpUI() {

    }

}
