//  MainTabBarController.swift
//  Market
//  Created by Хасан Магомедов on 05.10.2023.

import UIKit

final class MainTabBarController: UITabBarController {
    
    private var isFirstLaunch = true
    
    // MARK: - UI Elements
    
    private var productListViewController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: ProductListViewController())
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "folder"), selectedImage: nil)
        return navigationController
    }
    
    private var favoriteListViewController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: FavoriteListViewController())
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart"), selectedImage: nil)
        return navigationController
    }
    
    private var profileViewController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: nil)
        return navigationController
    }

    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [productListViewController, favoriteListViewController, profileViewController]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func showLoginScreen() {
        let vc = LoginViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.tintColor = .black
        present(navigationController, animated: true)
    }
}
