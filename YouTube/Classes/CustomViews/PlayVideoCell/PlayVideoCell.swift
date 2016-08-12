//
//  PlayVideoCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class PlayVideoCell: BaseTableViewCell {

    @IBOutlet weak var playVideoView: YTPlayerView!
    @IBOutlet weak var nameVideoLabel: UILabel!
    @IBOutlet weak var thumbnailVideo: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak private var subcribeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func setUpUI() {
        UIView.setBorder(self.subcribeButton, cornerRadius: 4.0, borderWidth: 1, borderColor: AppDefine.backgroundColor)
    }

}
