//
//  String+substring.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 06.03.2025.
//

import Foundation

extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}
