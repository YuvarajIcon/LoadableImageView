//
//  Int + Extensions.swift
//  HelpfulExtensions
//
//  Created by Yuvaraj on 30/05/22.
//

import Foundation

extension Int {
    public var ordinal: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self))
    }
}
