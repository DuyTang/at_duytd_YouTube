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
    @IBOutlet weak private var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Configure Cell
    func configureCell(video: Video) {
        thumbnailVideo.downloadImage(video.thumbnail)
        nameVideoLabel.text = video.title
        channelLabel.text = video.channelTitle
        countViewLabel.text = Int(video.viewCount) > 1 ? video.viewCount.getNumberView() : "\(video.viewCount) view"
        durationLabel.text = video.duration.convertDuration()
    }
    // MARk:- Set Up UI
    override func setUpUI() {

    }
    override func prepareForReuse() {
        thumbnailVideo.image = UIImage(named: "bg_video")
    }

}
