//
//  VideoFavoriteCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class VideoFavoriteCell: BaseTableViewCell {

    @IBOutlet weak private var thumbnailVideo: UIImageView!
    @IBOutlet weak private var nameVideoLabel: UILabel!
    @IBOutlet weak private var channelLabel: UILabel!
    @IBOutlet weak private var countViewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Configure Cell
    func configureCell(video: VideoFavorite) {
        thumbnailVideo.downloadImage(video.thumbnail)
        self.nameVideoLabel.text = video.title
        self.channelLabel.text = video.channelTitle
        self.countViewLabel.text = "\(video.viewCount) views"

    }
    // MARk:- Set Up UI
    override func setUpUI() {

    }

}
