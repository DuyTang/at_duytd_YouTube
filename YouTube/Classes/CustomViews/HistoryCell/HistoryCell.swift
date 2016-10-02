//
//  HistoryCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/17/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class HistoryCell: BaseTableViewCell {

    @IBOutlet weak private var thumbnailVideoImage: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var channelLabel: UILabel!
    @IBOutlet weak private var timeViewLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureHistoryCell(object: History) {
        self.thumbnailVideoImage.downloadImage(object.video.thumbnail)
        self.titleLabel.text = object.video.title
        self.channelLabel.text = object.video.channelTitle
        self.timeViewLabel.text = object.time
        durationLabel.text = object.video.duration.convertDuration()
    }

}

