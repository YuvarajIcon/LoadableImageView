//
//  UIDevice + Extensions.swift
//  HelpfulExtensions
//
//  Created by Yuvaraj on 30/05/22.
//

import Foundation

extension UIDevice {
    public class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    public class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    public class var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }

    public class var isCarPlay: Bool {
        return UIDevice.current.userInterfaceIdiom == .carPlay
    }
    
    public static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
    
    public class var hasNotch: Bool {
        if UIDevice.isPhone {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
    
    public class var iPhoneSafeAreaInsets: UIEdgeInsets? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return keyWindow?.safeAreaInsets
    }
}
