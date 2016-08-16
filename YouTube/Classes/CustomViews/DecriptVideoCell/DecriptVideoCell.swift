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
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureDecriptVideoCell(video: Video) {
        self.detailDecriptVideoLabel.text = video.descript
    }

}
