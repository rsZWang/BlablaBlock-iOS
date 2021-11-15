//
//  Utils.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import UIKit

class Utils {
    
    // Top most ViewController
    public static func findMostTopViewController() -> UIViewController? {
        if let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController {
            return visibleViewController
        } else {
            return nil
        }
    }
    
}
