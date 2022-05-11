//
//  String + Extensions.swift
//  HelpfulExtensions
//
//  Created by Yuvaraj on 11/05/22.
//

import Foundation
extension String {
    public var isValidUrl: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
