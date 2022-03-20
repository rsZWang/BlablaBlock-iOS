//
//  Coordinator.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

import UIKit

public protocol Coordinator: NSObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
