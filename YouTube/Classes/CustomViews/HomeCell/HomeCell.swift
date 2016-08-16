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
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    // MARK:- Configure Cell
    func configureCell(video: Video) {
        self.thumbnailVideo.downloadImage(video.thumbnail)
        self.thumbnailChannel.downloadImage(video.thumbnail)
        self.nameVideoLabel.text = video.title
        self.nameChannelLabel.text = video.channelTitle
        self.numberViewLabel.text = "\(video.viewCount) views"

    }
    // MARk:- Set Up UI
    override func setUpUI() {
        self.thumbnailChannel.setCircle(1.0, borderColor: AppDefine.backgroundColor)
    }

    override func prepareForReuse() {
        thumbnailVideo.image = nil
        thumbnailChannel.image = nil
    }

}
