//
//  DecriptVideoCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
class DecriptVideoCell: BaseTableViewCell {
    @IBOutlet private weak var detailDecriptVideoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureDecriptVideoCell(text: String, font: UIFont, color: UIColor) {
        detailDecriptVideoLabel.text = text
        detailDecriptVideoLabel.font = font
        detailDecriptVideoLabel.textColor = color
    }
}
