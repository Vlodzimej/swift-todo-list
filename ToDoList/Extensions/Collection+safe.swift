//
//  Collection+safe.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
