//
//  LoginView.swift
//  Market
//
//  Created by Хасан Магомедов on 12.10.2023.
//

import UIKit

final class LoginView: UIView {
    
    // MARK: - UI Elements
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Почта, номер телефона"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Пароль"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    let activityIndicatior: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        return activityIndicatorView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        setupEmailTextFieldLayout()
        setupPasswordTextFieldLayout()
        setupLoginButtonLayout()
        setupActivityIndicatorViewLayout()
    }
    
    private func setupEmailTextFieldLayout() {
        addSubview(emailTextField)
        
        emailTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
    
    private func setupPasswordTextFieldLayout() {
        addSubview(passwordTextField)
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
    
    private func setupLoginButtonLayout() {
        addSubview(loginButton)
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    private func setupActivityIndicatorViewLayout() {
        addSubview(activityIndicatior)
        
        activityIndicatior.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatior.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
