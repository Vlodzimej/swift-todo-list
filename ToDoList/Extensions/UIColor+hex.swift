//
//  UIColor+hex.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let rgbValue = hexStringToRgb(hex: hex)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    struct TaskList {
        static let background = UIColor(hex: "040404")
        static let foreground = UIColor(hex: "F4F4F4")
        //static let separator = UIColor(hex: "4D555E")
        static let separator = UIColor(hex: "F4F4F4").withAlphaComponent(0.5)
    }
}

fileprivate func hexStringToRgb(hex: String) -> UInt64 {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    return rgbValue
}
