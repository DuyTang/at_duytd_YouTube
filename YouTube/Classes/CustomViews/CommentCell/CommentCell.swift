//
//  CommentCell.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class CommentCell: BaseTableViewCell {

    @IBOutlet weak private var userThumbnail: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var timeCommentLabel: UILabel!
    @IBOutlet weak private var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCommentCell(comment: Comment) {
        userThumbnail.downloadImage(comment.topComment.authorProfileImageUrl)
        userNameLabel.text = comment.topComment.authorDisplayName
        timeCommentLabel.text = comment.topComment.publishedAt.convertTimeUpload()
        commentLabel.text = comment.topComment.textDisplay
    }

    override func setUpUI() {
        userThumbnail.setCircle(1.0, borderColor: Color.TitleColor)
    }
}
