//
//  PlayVideoCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

protocol PlayVideoCellDelegate {
    func clickExpandDescription(cell: PlayVideoCell)
}

class PlayVideoCell: BaseTableViewCell {

    @IBOutlet weak private var playVideoView: YTPlayerView!
    @IBOutlet weak private var nameVideoLabel: UILabel!
    @IBOutlet weak private var thumbnailVideo: UIImageView!
    @IBOutlet weak private var channelLabel: UILabel!
    @IBOutlet weak private var viewCountLabel: UILabel!
    @IBOutlet weak private var subcribeButton: UIButton!
    private var isRun = false
    private var isSubscribe = false
    var delegate: PlayVideoCellDelegate?
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
        self.subcribeButton.setCircle(1.0, borderColor: UIColor.blackColor())
        self.thumbnailVideo.setCircle(1.0, borderColor: AppDefine.backgroundColor)
    }

    @IBAction private func clickExpandDescription(sender: UIButton) {
        delegate?.clickExpandDescription(self)
    }
    @IBAction func changeSubscribe(sender: AnyObject) {
        if isSubscribe == false {
            self.subcribeButton.setCircle(1.0, borderColor: AppDefine.subscribeColor)
            self.subcribeButton.setImage(UIImage(named: "bt_sub_color"), forState: .Normal)
            self.isSubscribe = true
        } else {
            self.subcribeButton.setCircle(1.0, borderColor: UIColor.blackColor())
            self.subcribeButton.setImage(UIImage(named: "bt_sub"), forState: .Normal)
            self.isSubscribe = false
        }
    }

}
