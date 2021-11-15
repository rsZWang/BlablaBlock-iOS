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

public extension Int {
    var formattedNumeric: String {
        String(self).formattedNumeric
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
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
