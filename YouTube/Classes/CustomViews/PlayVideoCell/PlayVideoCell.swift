//
//  PlayVideoCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class PlayVideoCell: BaseTableViewCell {

    @IBOutlet weak private var nameVideoLabel: UILabel!
    @IBOutlet weak private var thumbnailVideo: UIImageView!
    @IBOutlet weak private var channelLabel: UILabel!
    @IBOutlet weak private var viewCountLabel: UILabel!
    @IBOutlet weak private var timeUploadLabel: UILabel!
    private var isRun = false
    private var isSubscribe = false
    private var isShow = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configPlayVideoCell(video: Video) {
        nameVideoLabel.text = video.title.isEmpty ? " " : video.title
        thumbnailVideo.downloadImage(video.thumbnail)
        channelLabel.text = video.channelTitle
        viewCountLabel.text = Int(video.viewCount) > 1 ? "\(video.viewCount) views" : "\(video.viewCount) view"
        timeUploadLabel.text = video.timeUpload.getTimeUpload()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func setUpUI() {
        thumbnailVideo.setCircle(1.0, borderColor: Color.BackgroundColor)
    }
}
