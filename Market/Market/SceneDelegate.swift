//
//  SceneDelegate.swift
//  Market
//
//  Created by Хасан Магомедов on 27.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
//        let navigationController = UINavigationController(rootViewController: ProductListViewController())
//        navigationController.navigationBar.tintColor = .black
        
        let rootViewController: UIViewController
        let isLoggedIn = UserDefaults.standard.integer(forKey: "currentUserId") > 0
        
        if isLoggedIn {
            let tabBar = MainTabBarController()
            tabBar.selectedIndex = 2
            rootViewController = tabBar
        } else {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigationBar.tintColor = .black
            rootViewController = nav
        }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

