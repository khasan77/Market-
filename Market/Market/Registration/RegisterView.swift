//
//  RegisterView.swift
//  Market
//
//  Created by Хасан Магомедов on 12.10.2023.
//

import UIKit

final class RegisterView: UIView {
    
    // MARK: - UI Elements
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 100
        imageView.image = UIImage(named: "user")
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Имя"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Почта"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Пароль"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
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
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupUserImageViewLayout()
        setupNameTextFieldLayout()
        setupEmailTextFieldLayout()
        setupPasswordTextFieldLayout()
        setupRegisterButtonLayout()
        setupActivityIndicatorViewLayout()
    }
    
    // MARK: - Private methods
    
    private func setupUserImageViewLayout() {
        addSubview(userImageView)
        
        userImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupNameTextFieldLayout() {
        addSubview(nameTextField)
        
        nameTextField.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
    
    private func setupEmailTextFieldLayout() {
        addSubview(emailTextField)
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16).isActive = true
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
    
    private func setupRegisterButtonLayout() {
        addSubview(registerButton)
        
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    private func setupActivityIndicatorViewLayout() {
        addSubview(activityIndicatior)
        
        activityIndicatior.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatior.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
