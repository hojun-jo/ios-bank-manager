//
//  BankManagerUIApp - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController: ViewController = ViewController()
        let navigationController: UINavigationController = UINavigationController(rootViewController : viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

