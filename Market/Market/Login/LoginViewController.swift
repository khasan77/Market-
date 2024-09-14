//  LoginViewController.swift
//  Market
//  Created by Хасан Магомедов on 12.10.2023.

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = LoginView()
    
    // MARK: - Lyfecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Авторизация"
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newRegisterButtonTapped))
        
        mainView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    
    @objc
    private func loginButtonTapped() {
        mainView.activityIndicatior.startAnimating()
        navigationController?.dismiss(animated: true)
    }
    
    @objc
    private func newRegisterButtonTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
