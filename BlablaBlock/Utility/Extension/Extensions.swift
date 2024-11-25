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
    
    func toPrettyPrecisedString(precision: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = precision
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: rounded(toPlaces: precision))) ?? "\(self)"
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

public extension NSError {
    
    static func create(domain: String, code: Int) -> NSError {
        NSError(domain: domain, code: code, userInfo: nil)
    }
    
    static func create(_ failure: ResponseFailure) -> NSError {
        NSError(domain: failure.message, code: 000, userInfo: nil)
    }
}

public extension UIImageView {
    
    func currency(name: String) {
        let lowercase = name.lowercased()
        image = UIImage(named: lowercase) ?? UIImage(named: "currency_unknown")
    }
}

public extension UIRefreshControl {
    func beginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        tableView.setContentOffset(
            CGPoint.init(x: 0, y: -frame.size.height),
            animated: true
        )
    }
}

public extension TimeInterval {
    
    func format(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func ago() -> String {
        let when = Date(timeIntervalSince1970: self)
        let current = Date()
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: current)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: current)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: current)!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: current)!

        if minuteAgo < when {
            let diff = Calendar.current.dateComponents([.second], from: when, to: current).second ?? 0
            return "\(diff) 秒鐘前"
        } else if hourAgo < when {
            let diff = Calendar.current.dateComponents([.minute], from: when, to: current).minute ?? 0
            return "\(diff) 分鐘前"
        } else if dayAgo < when {
            let diff = Calendar.current.dateComponents([.hour], from: when, to: current).hour ?? 0
            return "\(diff) 個小時前"
        } else if weekAgo < when {
            let diff = Calendar.current.dateComponents([.day], from: when, to: current).day ?? 0
            return "\(diff) 天前"
        } else {
            let diff = Calendar.current.dateComponents([.weekOfYear], from: when, to: current).weekOfYear ?? 0
            return "\(diff) 個禮拜前"
        }
    }
}

public extension UITableView {
    
    func reloadVisibleCells() {
        guard let visibleRows = indexPathsForVisibleRows else { return }
        beginUpdates()
        reloadRows(at: visibleRows, with: .none)
        endUpdates()
    }
}


public extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

public extension UIImage {
    
    func resize(scale: CGFloat) -> UIImage {
        let newWidth = self.size.width * scale
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

public extension UILabel {
    func autoFontSize() {
        numberOfLines = 1
        adjustsFontSizeToFitWidth = true
    }
}
