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
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    // MARK:- Configure Cell
    func configureCell(video: Video) {
        thumbnailVideo.downloadImage(video.thumbnail)
        self.nameVideoLabel.text = video.title
        self.nameChannelLabel.text = video.channelTitle
        self.numberViewLabel.text = "\(video.viewCount) views"
    }
    // MARk:- Set Up UI
    override func setUpUI() {

    }

}
