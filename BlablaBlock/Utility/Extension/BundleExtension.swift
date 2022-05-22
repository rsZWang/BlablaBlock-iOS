//
//  BundleExtension.swift
//  BlablaBlock
//
//  Created by Harry on 2022/5/22.
//

import Foundation

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {

    override func localizedString(
        forKey key: String,
        value: String?,
        table tableName: String?
    ) -> String {

        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String, let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

public extension Bundle {
    var appName: String {
        infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        bundleIdentifier!
    }

    var versionNumber: String {
        infoDictionary!["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        infoDictionary!["CFBundleVersion"] as! String
    }
    
    var versionString: String {
        "v \(versionNumber)"
    }
    
    class func setLanguage(_ language: String) {

        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
