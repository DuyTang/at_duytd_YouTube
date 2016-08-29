//
//  UIViewExtension.swift
//  CardBook
//
//  Created by AsianTech on 12/18/15.
//  Copyright © 2015 Asian Tech Co.,Ltd. All rights reserved.
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
    
    func customSnapshoFromView() -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -0.5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    
    static func getSizeofNib() -> CGSize? {
        return (NSBundle.mainBundle().loadNibNamed(self.identifier, owner: self, options: nil).first as? UIView)?.frame.size
    }
    
    func setBorder(boderColer: UIColor?, boderwith: CGFloat?, radius: CGFloat?) {
        self.clipsToBounds = true
        if let boderColer = boderColer {
            self.layer.borderColor = boderColer.CGColor
        }
        if let radius = radius {
            self.layer.cornerRadius = radius
        }
        if let boderwith = boderwith {
            self.layer.borderWidth = boderwith
        }
    }
    
    func showLikePopUp() {
        self.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        UIView.animateWithDuration(0.7, delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 1.0,
                                   options: .TransitionNone,
                                   animations: {
                                    self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            }, completion: nil)
    }
    
    func makeBackgroudGradientOrange() {
        let arrayColor = [UIColor.rgbColor(redColor: 255, greenColor: 139, blueColor: 44).CGColor,
                          UIColor.rgbColor(redColor: 244, greenColor: 110, blueColor: 44).CGColor]
        let _ = self.layer.sublayers?.filter({ $0.name == "GradientBackground" }).map({ $0.removeFromSuperlayer() })
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBackground"
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.colors = arrayColor
        layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func makeBackgroudShadow() {
        let arrayColor = [UIColor.clearColor().CGColor,
                          UIColor.rgbaColor(redColor: 0, greenColor: 0, blueColor: 0, alphaNumber: 0.2).CGColor]
        let _ = self.layer.sublayers?.filter({ $0.name == "ShadownBackground" }).map({ $0.removeFromSuperlayer() })
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "ShadownBackground"
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.colors = arrayColor
        
        layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func removeGradient() {
        let _ = self.layer.sublayers?.filter({ $0.name == "GradientBackground" }).map({ $0.removeFromSuperlayer() })
        layer.mask?.removeFromSuperlayer()
    }
    
    func makeShadow(offset offset: CGSize, color: UIColor, opacity: Float, radius: CGFloat) {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.shadowColor = color.CGColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowPath = shadowPath.CGPath
        self.layer.masksToBounds = false
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
    
    func makeCornerRadius(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func makeBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
    }
    
    func makeBorderDotted(width: CGFloat, color: UIColor) {
        let _ = self.layer.sublayers?.filter({ $0.name == "DashedBorder" }).map({ $0.removeFromSuperlayer() })
        let border = CAShapeLayer()
        border.name = "DashedBorder"
        border.lineJoin = kCALineCapRound
        border.strokeColor = color.CGColor
        border.fillColor = nil
        border.lineDashPattern = [6, 3]
        border.lineWidth = width
        border.path = UIBezierPath(rect: bounds).CGPath
        border.frame = bounds
        layer.insertSublayer(border, atIndex: 0)
    }
}
