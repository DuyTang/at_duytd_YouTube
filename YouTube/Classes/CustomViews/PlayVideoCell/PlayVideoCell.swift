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
    @IBOutlet weak var showDecriptionButton: UIButton!
    private var isRun = false
    private var isSubscribe = false
    private var isShow = false
    var delegate: PlayVideoCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configPlayVideoCell(video: Video) {
        nameVideoLabel.text = video.title.isEmpty ? " " : video.title
        thumbnailVideo.downloadImage(video.thumbnail)
        channelLabel.text = video.channelTitle
        viewCountLabel.text = video.viewCount + " views"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func setUpUI() {
        subcribeButton.setCircle(1.0, borderColor: UIColor.blackColor())
        thumbnailVideo.setCircle(1.0, borderColor: Color.BackgroundColor)
    }

    @IBAction private func clickExpandDescription(sender: UIButton) {
        delegate?.clickExpandDescription(self)
    }
    @IBAction func changeSubscribe(sender: AnyObject) {
        if isSubscribe == false {
            subcribeButton.setCircle(1.0, borderColor: Color.SubscribeColor)
            subcribeButton.setImage(UIImage(named: "bt_sub_color"), forState: .Normal)
            isSubscribe = true
        } else {
            subcribeButton.setCircle(1.0, borderColor: UIColor.blackColor())
            subcribeButton.setImage(UIImage(named: "bt_sub"), forState: .Normal)
            isSubscribe = false
        }
    }

    @IBAction func showDecriptionVideo(sender: AnyObject) {
        if isShow {
            showDecriptionButton.setImage(UIImage(named: "bt_expand"), forState: .Normal)
            isShow = false
        } else {
            showDecriptionButton.setImage(UIImage(named: "bt_collapse"), forState: .Normal)
            isShow = true
        }

    }
}
