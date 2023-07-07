//
//  Array+IndexesOf.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import Foundation

// This extension gets an element and returns the indexes of this element in an array
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
