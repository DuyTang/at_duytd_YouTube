//
//  HomeCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class HomeCell: BaseTableViewCell {

    @IBOutlet weak private var thumbnailVideo: UIImageView!
    @IBOutlet weak private var nameVideoLabel: UILabel!
    @IBOutlet weak private var nameChannelLabel: UILabel!
    @IBOutlet weak private var numberViewLabel: UILabel!
    @IBOutlet weak private var thumbnailChannel: UIImageView!
    @IBOutlet weak private var timeUploadLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    // MARK:- Configure Cell
    func configureCell(video: Video) {
        thumbnailVideo.downloadImage(video.thumbnail)
        thumbnailChannel.downloadImage(video.thumbnail)
        nameVideoLabel.text = video.title
        nameChannelLabel.text = video.channelTitle
        numberViewLabel.text = Int(video.viewCount) > 1 ? "\(video.viewCount.getNumberView()) -" : "\(video.viewCount) view -"
        timeUploadLabel.text = video.timeUpload.getTimeUpload()
        durationLabel.text = video.duration.getYoutubeFormattedDuration()
    }
    // MARk:- Set Up UI
    override func setUpUI() {
        thumbnailChannel.setCircle(1.0, borderColor: Color.BackgroundColor)
    }

    override func prepareForReuse() {
        thumbnailVideo.image = nil
        thumbnailChannel.image = nil
    }

}
