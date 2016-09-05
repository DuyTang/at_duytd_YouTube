//
//  ButtonCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/31/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
protocol ButtonCellDelegate {
    func clickExpandDescription(cell: ButtonCell)
}
class ButtonCell: BaseTableViewCell {
    var delegate: ButtonCellDelegate?
    var isShow = false

    @IBOutlet weak var showButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func showDecript(sender: AnyObject) {
        delegate?.clickExpandDescription(self)
    }
    @IBAction func changeTitle(sender: AnyObject) {
        if isShow {
            showButton.setTitle("Show More", forState: .Normal)
            isShow = false
        } else {
            showButton.setTitle("Hide", forState: .Normal)
            isShow = true
        }
    }
}
