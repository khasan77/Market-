//
//  ProfileViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 12.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = ProfileView()
    
    // MARK: - Lyfecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Профиль"
        
        mainView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchDown)
        
        mainView.showOrdersView.addTarget(self, action: #selector(showOrdersButtonTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    
    @objc
    private func logoutButtonTapped() {
        let alert = UIAlertController(title: "Выход из аккаунта", message: "Вы действительно хотите выйти из аккаунта?", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            let vc = LoginViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.tintColor = .black
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func showOrdersButtonTapped() {
        let vc = OrderListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
