//
//  UIColor+Extension.swift
//  Ocvang
//
//  Created by PhuongVNC on 8/21/16.
//  Copyright © 2016 Ocvang. All rights reserved.
//

import Foundation

import UIKit

/**
 * Custom category of UIColor to load the custom colors according to the selected themes.
 */

extension UIColor {

    class func rgbColor(redColor red: Float, greenColor green: Float, blueColor blue: Float) -> UIColor {
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
    }

    class func rgbaColor(redColor red: Float, greenColor green: Float, blueColor blue: Float, alphaNumber alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: alpha)
    }

    class func makeColorWithHexString(hex: String) -> UIColor {
        var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

        if cString.hasPrefix("#") {
            cString = (cString as NSString).substringFromIndex(1)
        }

        if cString.characters.count != 6 {
            return UIColor.grayColor()
        }

        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)

        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

    class func tabBarColor() -> UIColor {
        return UIColor.rgbColor(redColor: 229, greenColor: 229, blueColor: 229)
    }

    class func navBarColor() -> UIColor {
        return UIColor.rgbColor(redColor: 241, greenColor: 93, blueColor: 81)
    }

    class func textColor() -> UIColor {
        return UIColor.rgbColor(redColor: 76, greenColor: 76, blueColor: 76)
    }

}
