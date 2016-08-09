//
//  CategoryCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class CategoryCell: BaseCollectionViewCell {

    @IBOutlet weak var nameCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    // MARK:- Action
    func changFont(isSelected: Bool) {
        if isSelected {
            nameCategoryLabel.font = UIFont(name: AppDefine.SelectedFont, size: AppDefine.FontSize)
        } else {
            nameCategoryLabel.font = UIFont(name: AppDefine.Font, size: AppDefine.FontSize)
        }
    }
    // MARK:- Configure Cell
    func configureCategoryCell() {
        self.nameCategoryLabel.text = "Category"
    }
    // MARK:- Set Up UI
    private func setUpUI() {

    }

}
