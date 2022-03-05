//
//  View.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import Foundation
import UIKit

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
    
    func fadeIn(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.alpha = 0
            },
            completion: { completed in
                if completed {
                    completion?()
                }
            }
        )
    }
    
    func fadeOut(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.alpha = 1
            },
            completion: { completed in
                if completed {
                    completion?()
                }
            }
        )
    }
    
    func fadeAndHide(isHidden: Bool) {
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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func makeCircle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

public extension UILabel {
    func autoResize(
        font: UIFont,
        scaleFactor: CGFloat = 0.5
    ) {
        self.font = font
        minimumScaleFactor = scaleFactor
        numberOfLines = 0
        adjustsFontSizeToFitWidth = true
        lineBreakMode = .byClipping
    }
}

public extension UIApplication {
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
