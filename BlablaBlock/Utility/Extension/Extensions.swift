//
//  Extensions.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit

// MARK: - NibOwnerLoadable
public protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}

// MARK: - Default implmentation
public extension NibOwnerLoadable {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: - Supporting methods
public extension NibOwnerLoadable where Self: UIView {
    func loadNibContent() {
        guard let views = Self.nib.instantiate(
            withOwner: self,
            options: nil
        ) as? [UIView], let contentView = views.first else {
            fatalError("Fail to load \(self) nib content")
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

public protocol Formattable {
    func withCommas() -> String
}

public extension Array {
    var isNotEmpty: Bool {
        get { !isEmpty }
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
}

public extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    var visibleViewController: UIViewController? {
        UIWindow.visibleViewController(from: rootViewController)
    }

    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
            case let navigationController as UINavigationController:
                return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)
            case let tabBarController as UITabBarController:
                return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            case let presentingViewController where viewController?.presentedViewController != nil:
                return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
            default:
                return viewController
        }
    }
}

public extension Data {
    /// NSString gives us a nice sanitized debugDescription
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
    
    var utf8String: String {
        String(decoding: self, as: UTF8.self)
    }
}

public extension Int {
    
    var formattedNumeric: String {
        withCommas()
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}

public extension Double {
    
    var string: String {
        String(self)
    }
    
    var formatted: String {
        withCommas()
    }
    
    func toPrecisedString(percision: Int = 2) -> String {
        String(format: "%.\(percision)f", self)
    }
    
    func toPrettyPrecisedString(precision: Int = 2) -> String {
        toPrecisedString(percision: precision).double.withCommas()
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}

public extension NSError {
    
    static func create(domain: String, code: Int) -> NSError {
        NSError(domain: domain, code: code, userInfo: nil)
    }
    
    static func create(_ failure: ResponseFailure) -> NSError {
        NSError(domain: failure.msg, code: failure.code, userInfo: nil)
    }
    
}

public extension Date {
    func agoString() -> String {

        let current = Date()
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: current)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: current)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: current)!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: current)!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: current).second ?? 0
            return "\(diff) 秒鐘前"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: current).minute ?? 0
            return "\(diff) 分鐘前"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: current).hour ?? 0
            return "\(diff) 個小時前"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: current).day ?? 0
            return "\(diff) 天前"
        } else {
            let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: current).weekOfYear ?? 0
            return "\(diff) 個禮拜前"
        }
    }
}
