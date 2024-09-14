//
//  OrderConfirmationView.swift
//  Market
//
//  Created by Хасан Магомедов on 11.10.2023.
//

import UIKit

protocol OrderConfirmationViewDelegate: AnyObject {
    func confirmButtonTapped()
}

class OrderConfirmationView: UIView {
    
    typealias Delegate = OrderConfirmationViewDelegate & UITableViewDelegate
    
    // MARK: - Properties
    
    weak var delegate: Delegate? {
        didSet {
            productsTableView.delegate = delegate
        }
    }
    
    var price: String? {
        didSet {
            guard let price = price else { return }
            priceLabel.text = "Итого: \(price)$"
        }
    }
    
    var dataSource: UITableViewDataSource? {
        didSet {
            productsTableView.dataSource = dataSource
        }
    }
    
    // MARK: - UI Elements
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Ваше имя"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Номер телефона"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 140
        tableView.isScrollEnabled = false 
        return tableView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        setupActions()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchDown)
    }
    
    @objc
    private func confirmButtonTapped() {
        delegate?.confirmButtonTapped()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupNameTextFieldLayout()
        setupPhoneNumberTextFiledLayout()
        setupPriceLabelLayout()
        setupProductsTableViewLayout()
        setupConfirmButtonLayout()
    }
    
    // MARK: - Private methods
    
    private func setupNameTextFieldLayout() {
        addSubview(nameTextField)
        
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
    
    private func setupPhoneNumberTextFiledLayout() {
        addSubview(phoneNumberTextField)
        
        phoneNumberTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        phoneNumberTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
    
    private func setupPriceLabelLayout() {
        addSubview(priceLabel)
        
        priceLabel.leadingAnchor.constraint(equalTo: phoneNumberTextField.leadingAnchor, constant: 16).isActive = true
        priceLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 24).isActive = true
    }
    
    private func setupProductsTableViewLayout() {
        addSubview(productsTableView)
        
        productsTableView.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        productsTableView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        productsTableView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
        productsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        productsTableView.register(FavoriteListTableViewCell.self, forCellReuseIdentifier: FavoriteListTableViewCell.identifier)
    }
    
    private func setupConfirmButtonLayout() {
        addSubview(confirmButton)
        
        confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
