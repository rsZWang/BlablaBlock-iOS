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

public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func getColor(named: String) -> UIColor? {
        UIColor(named: named, in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
    
    func getImage(named: String) -> UIImage? {
        UIImage(named: named, in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
    
    func getString(_ key: String, comment: String) -> String {
        NSLocalizedString(key, tableName: nil, bundle: Bundle(for: type(of: self)), comment: comment)
    }
    
    func rotate(duration: Double) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func findMostTopParent(start: Bool = true) -> UIView? {
        if let parent = superview {
            return parent.findMostTopParent(start: false)
        } else {
            if start {
                return nil
            } else {
                return self
            }
        }
    }
    
    func fade(isHidden: Bool) {
        if isHidden == true {
            UIView.animate(
                withDuration: 0.3,
                animations: { [weak self] in
                    self?.alpha = 0
                }
            ) { [weak self] finished in
                self?.isHidden = true
            }
        } else {
            self.alpha = 0
            self.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
}

public extension UIViewController {
    
    func present(storyboard: String, name: String, animated: Bool = true) {
        present(
            UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: name),
            animated: animated
        )
    }
    
    func present<T>(storyboard: String, name: String, animated: Bool = true, apply: ((T) -> Void)? = nil) {
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: name)
        apply?(viewController as! T)
        present(viewController, animated: animated)
    }
    
    func push(storyboard: String, identifier: String, animated: Bool = true) {
        navigationController!.pushViewController(
            UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier),
            animated: animated
        )
    }
    
    func push<T>(storyboard: String, identifier: String, animated: Bool = true, apply: ((T) -> Void)? = nil)  {
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        apply?(viewController as! T)
        navigationController!.pushViewController(viewController, animated: animated)
    }
    
    func push(vc: UIViewController, animated: Bool = true) {
        navigationController!.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController!.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController!.popToRootViewController(animated: animated)
    }
    
    func popTo<T>(_ target: T.Type, animated: Bool = true) {
        for viewController in navigationController!.viewControllers {
            if viewController is T {
                navigationController!.popToViewController(viewController, animated: animated)
                return
            }
        }
    }
    
    var isNavBottomVisible: Bool {
        get { tabBarController?.tabBar.isHidden ?? true }
        set { tabBarController?.tabBar.isHidden = !newValue }
    }
    
    func touchDismissKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
           let statusBar =  UIView()
            statusBar.frame = UIApplication.shared.statusBarFrame
            UIApplication.shared.keyWindow?.addSubview(statusBar)
            return statusBar
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            return statusBar
        }
    }
}

extension UIImageView {
    func makeCircle() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
