//
//  FavoriteCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak private var thumbnailFavoriteList: UIImageView!

    @IBOutlet weak private var nameFavoriteListLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureFavoriteCell() {
        self.nameFavoriteListLabel.text = "Favorite"
    }

    private func setUpUI() {
        configureFavoriteCell()
    }

}
