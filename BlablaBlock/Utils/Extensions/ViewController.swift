//
//  ViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import UIKit

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

