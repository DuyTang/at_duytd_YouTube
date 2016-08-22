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
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    // MARK:- Action
    func changFont(isSelected: Bool) {
        if isSelected {
            self.nameCategoryLabel.font = UIFont(name: AppDefine.SelectedFont, size: AppDefine.FontSize)
            self.nameCategoryLabel.textColor = UIColors.BorderColor
        } else {
            nameCategoryLabel.font = UIFont(name: AppDefine.Font, size: AppDefine.FontSize)
            self.nameCategoryLabel.textColor = UIColors.CategoryTextColor
        }
    }
    // MARK:- Configure Cell
    func configureCategoryCell(category: Category) {
        self.nameCategoryLabel.text = category.title
    }
    // MARK:- Set Up UI
    private func setUpUI() {

    }

}
