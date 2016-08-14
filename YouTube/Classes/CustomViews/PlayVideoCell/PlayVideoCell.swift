//
//  PlayVideoCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class PlayVideoCell: BaseTableViewCell {

    @IBOutlet weak private var playVideoView: YTPlayerView!
    @IBOutlet weak private var nameVideoLabel: UILabel!
    @IBOutlet weak private var thumbnailVideo: UIImageView!
    @IBOutlet weak private var channelLabel: UILabel!
    @IBOutlet weak private var viewCountLabel: UILabel!
    @IBOutlet weak private var subcribeButton: UIButton!
    private var isRun = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configPlayVideoCell(video: Video) {
        if !isRun {
            isRun = true
            self.nameVideoLabel.text = video.title.isEmpty ? " " : video.title
            self.thumbnailVideo.downloadImage(video.thumbnail)
            self.channelLabel.text = video.channelTitle
            self.viewCountLabel.text = video.viewCount + " views"
        }

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func setUpUI() {
        self.subcribeButton.setCircle(1.0, borderColor: 0x000000)
        self.thumbnailVideo.setCircle(1.0, borderColor: AppDefine.backgroundColor)
    }

}
