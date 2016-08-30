//
//  UIView.swift
//  YouTube
//
//  Created by Duy Tang on 8/9/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//
import UIKit

extension UIView {
    static var identifier: String {
        let str = NSStringFromClass(self)
        let last = str.componentsSeparatedByString(".").last
        return last!
    }
    
    static func instanceFromNib() -> UIView {
        return (UINib(nibName: self.identifier, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView)!
    }
    static func loadBundle() -> UIView {
        return (NSBundle.mainBundle().loadNibNamed(self.identifier, owner: self, options: nil).first as? UIView)!
    }
    
    func setBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
    func setCircle(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
    
    func findImageView() -> UIImageView? {
        let imageView = subviews.filter { (subView) -> Bool in
            if subView.isKindOfClass(UIImageView) {
                return true
            }
            return false
        }
        return imageView.count > 0 ? imageView[0] as? UIImageView : nil
    }
    
    func findLabel() -> UILabel? {
        let imageView = subviews.filter { (subView) -> Bool in
            if subView.isKindOfClass(UILabel) {
                return true
            }
            return false
        }
        return imageView.count > 0 ? imageView[0] as? UILabel : nil
    }
}
