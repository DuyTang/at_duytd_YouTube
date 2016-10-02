//
//  TabBarView.swift
//  YouTube
//
//  Created by Duy Tang on 8/29/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

enum ButtonItemType: Int {
    case Home = 0
    case Trending
    case Favorite
    case PlayList
    case History

    var nonSelectImage: String {
        switch self {
        case Favorite:
            return "ic_favorite"
        case .Home:
            return "ic_home"
        case .Trending:
            return "ic_trending"
        case .History:
            return "ic_history"
        case .PlayList:
            return "ic_chanel"
        }
    }

    var selectImage: String {
        switch self {
        case Favorite:
            return "ic_selectfavorite"
        case .Home:
            return "ic_selecthome"
        case .Trending:
            return "ic_selecttrending"
        case .History:
            return "ic_selecthistory"
        case .PlayList:
            return "ic_selectchanel"
        }
    }
}

protocol TabBarViewDelegate {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int)
}

class TabBarView: UIView {
    @IBOutlet private var itemView: [UIView]!
    var delegate: TabBarViewDelegate!
    var index: Int = 0 {
        willSet {
            let oldview = itemView[index]
            oldview.backgroundColor = UIColor.clearColor()
            if let imageView = oldview.findImageView(), label = oldview.findLabel() {
                imageView.image = UIImage(named: ButtonItemType(rawValue: index)!.nonSelectImage)
                label.textColor = Color.CategoryTextColor
            }
            let newView = itemView[newValue]
            newView.backgroundColor = Color.NavBarColor

            if let imageView = newView.findImageView(), label = newView.findLabel() {
                imageView.image = UIImage(named: ButtonItemType(rawValue: newValue)!.selectImage)
                label.textColor = UIColor.whiteColor()
            }
        }
    }

    @IBAction private func selectTabBarItem(sender: AnyObject) {
        let tag = sender.tag
        if tag != index {
            index = tag
            delegate.tabBarView(self, didSelectIndex: tag)
        }

    }

}
