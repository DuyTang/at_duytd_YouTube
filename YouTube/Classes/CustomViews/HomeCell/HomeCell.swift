//
//  HomeCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var thumbailVideo: UIImageView!
    @IBOutlet weak var nameVideoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureCell() {
        self.nameVideoLabel.text = "Video"
    }

    private func setUpUI() {
        configureCell()
    }

}
