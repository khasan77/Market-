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
        guard let phone = mainView.phoneTextField.text, !phone.isEmpty,
              let password = mainView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите номер телефона и пароль")
            return
        }
        
        mainView.activityIndicatior.startAnimating()
        mainView.loginButton.isEnabled = false
        
        AuthService.shared.login(phone: phone, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.mainView.activityIndicatior.stopAnimating()
                self?.mainView.loginButton.isEnabled = true
                
                switch result {
                case .success(let userResponse):
                    UserDefaults.standard.set(userResponse.userId, forKey: "currentUserId")
                    UserDefaults.standard.set(userResponse.customerName, forKey: "currentUserName")
                    UserDefaults.standard.set(userResponse.customerPhone, forKey: "currentUserPhone")
                    
                    let tabBar = MainTabBarController()
                    tabBar.selectedIndex = 2
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else { return }
                    
                    UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
                        window.rootViewController = tabBar
                    }
                    
                case .failure(let error):
                    var errorMessage = "Произошла ошибка"
                    switch error {
                    case .networkError:
                        errorMessage = "Ошибка сети. Проверьте подключение к интернету"
                    case .serverError(let message):
                        errorMessage = message
                    case .invalidURL:
                        errorMessage = "Неверный URL сервера"
                    case .noData:
                        errorMessage = "Нет данных от сервера"
                    case .decodingError, .invalidResponse:
                        errorMessage = "Ошибка обработки данных"
                    }
                    self?.showAlert(title: "Ошибка входа", message: errorMessage)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc
    private func newRegisterButtonTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
