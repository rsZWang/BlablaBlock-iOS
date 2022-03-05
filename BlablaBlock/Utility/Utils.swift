//
//  Utils.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import UIKit

public class Utils {
    
    // Top most ViewController
    public static func findMostTopViewController() -> UIViewController? {
        if let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController {
            return visibleViewController
        } else {
            return nil
        }
    }
    
    public static func getThreadName() -> String {
        if Thread.current.isMainThread {
            return "Main Thread"
        } else if let name = Thread.current.name {
            if name == "" {
                return "Anonymous Thread"
            } else {
                return name
            }
        } else {
            return "Unknown Thread"
        }
    }
    
}
