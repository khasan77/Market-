//
//  ProfileView.swift
//  Market
//
//  Created by Хасан Магомедов on 12.10.2023.
//

import UIKit

final class ProfileView: UIView {
    
    var username: String? {
        didSet {
            userNameLabel.text = username
        }
    }
    
    // MARK: - UI Elements
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 75
        imageView.image = UIImage(named: "user")
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    var userPhoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.text = ""
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    let showOrdersView = ShowOrdersView()
    
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
        setupUserImageView()
        setupUserNameLabelLayout()
        setupLogoutButtonLayout()
        setupShowOrdersViewLayout()
    }
    
    private func setupUserImageView() {
        addSubview(userImageView)
        
        userImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setupUserNameLabelLayout() {
        addSubview(userNameLabel)
        addSubview(userPhoneLabel)
        
        userNameLabel.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8).isActive = true
        
        userPhoneLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userPhoneLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    private func setupLogoutButtonLayout() {
        addSubview(logoutButton)
        
        logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupShowOrdersViewLayout() {
        addSubview(showOrdersView)
        
        showOrdersView.translatesAutoresizingMaskIntoConstraints = false
        
        showOrdersView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        showOrdersView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        showOrdersView.topAnchor.constraint(equalTo: userPhoneLabel.bottomAnchor, constant: 32).isActive = true
    }
}
