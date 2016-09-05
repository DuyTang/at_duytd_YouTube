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

    func configureHistoryCell(video: History) {
        self.thumbnailVideoImage.downloadImage(video.thumbnail)
        self.titleLabel.text = video.title
        self.channelLabel.text = video.channelTitle
        self.timeViewLabel.text = video.time
        durationLabel.text = video.duration.convertDuration()
    }

}

