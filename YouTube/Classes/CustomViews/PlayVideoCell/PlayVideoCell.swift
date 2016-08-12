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
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }

    func configPlayVideoCell(video: Video) {
        self.playVideoView.loadWithVideoId(video.idVideo)
        self.nameVideoLabel.text = video.title
        self.thumbnailVideo.downloadImage(video.thumbnail)
        self.channelLabel.text = video.channelTitle
        self.viewCountLabel.text = video.viewCount
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func setUpUI() {
        self.subcribeButton.setBorder(4.0, borderWidth: 1, borderColor: AppDefine.backgroundColor)
    }

}
