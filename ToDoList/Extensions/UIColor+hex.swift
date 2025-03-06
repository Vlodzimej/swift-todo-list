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
    
    // MARK: TaskList Colors
    struct TaskList {
        
        // MARK: Background
        struct Background {
            static let primary = UIColor(hex: "040404")
            static let second = UIColor(hex: "272729")
        }

        // MARK: Foreground
        struct Foreground {
            static let primary = UIColor(hex: "F4F4F4")
            static let second = UIColor(hex: "F4F4F4").withAlphaComponent(0.5)
        }

        // MARK: Element
        struct Element {
            static let separator = UIColor(hex: "4D555E")
            static let placeholder = UIColor(hex: "212123")
            static let button = UIColor(hex: "FED702")
        }
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
