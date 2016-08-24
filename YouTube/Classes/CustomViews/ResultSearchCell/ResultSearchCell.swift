//
//  ResultSearchCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/24/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class ResultSearchCell: BaseTableViewCell {

    @IBOutlet weak private var nameVideoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configResultSearchCell(text: String) {
        nameVideoLabel.text = text
    }

}
