//
//  TabBarView.swift
//  YouTube
//
//  Created by Duy Tang on 8/29/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

enum ButtonItemType: Int {
    case Favorite = 0
    case Home
    case Trending
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
        }
    }
    
    var selectImage: String {
        switch self {
        case Favorite:
            return "ic_favorite"
        case .Home:
            return "ic_home"
        case .Trending:
            return "ic_trending"
        case .History:
            return "ic_history"
        }
    }
}

protocol TabBarViewDelegate {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int)
}


class TabBarView: UIView {
    @IBOutlet var itemView: [UIView]!
    var delegate: TabBarViewDelegate!
    var index: Int = 0 {
        willSet {
            let oldview = itemView[index]
            oldview.backgroundColor = UIColor.clearColor()
            if let imageView = oldview.findImageView(), label = oldview.findLabel() {
                imageView.image = UIImage(named: ButtonItemType(rawValue: index)!.nonSelectImage)
                label.textColor = UIColor.textColor()
            }
            let newView = itemView[newValue]
            newView.backgroundColor = UIColor.navBarColor()
            
            if let imageView = newView.findImageView(), label = newView.findLabel() {
                imageView.image = UIImage(named: ButtonItemType(rawValue: newValue)!.selectImage)
                label.textColor = UIColor.whiteColor()
            }
        }
    }
    
    @IBAction func selectTabBarItem(sender: AnyObject) {
        let tag = sender.tag
        if tag != index {
            index = tag
            delegate.tabBarView(self, didSelectIndex: tag)
        }
        
    }
    
}
