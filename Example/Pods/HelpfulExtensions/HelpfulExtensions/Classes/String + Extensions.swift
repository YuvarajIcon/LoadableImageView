//
//  String + Extensions.swift
//  HelpfulExtensions
//
//  Created by Yuvaraj on 11/05/22.
//

import Foundation
extension String {
    private func isValidMail() -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return predicate.evaluate(with: self)
    }
    
    public var isValidEmail: Bool {
        return self.isValidMail()
    }
    
    public var unformattedPhoneNumber: String? {
        return replacingOccurrences(of: "[^+0-9]", with: "", options: .regularExpression)
    }
    
    public var isValidPhoneNumber: Bool {
        if countryCode?.count == 3, phoneNumberWithoutCode?.count == 10 {
            return true
        }
        return false
    }

    public var countryCode: String? {
        get {
            if let unformattedText = unformattedPhoneNumber, unformattedText.count >= 3 {
                return (unformattedText as NSString).substring(to: 3)
            }
            return nil
        }
    }

    public var phoneNumberWithoutCode: String? {
        get {
            if let unformattedText = unformattedPhoneNumber, unformattedText.count >= 3 {
                return (unformattedText as NSString).substring(from: 3)
            }
            return nil
        }
    }
    
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
    
    public func upto(_ char: String) -> String? {
        return self.components(separatedBy: char).first
    }
}
