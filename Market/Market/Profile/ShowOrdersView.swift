//
//  ShowOrdersView.swift
//  Market
//
//  Created by Хасан Магомедов on 17.10.2023.
//

import UIKit

final class ShowOrdersView: UIControl {
    
    // MARK: - UI Elements
    
    private let myOrdersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19)
        label.text = "Мои заказы"
        return label
    }()
    
    private let chevronIcon: UIImageView = {
        let chevronIcon = UIImageView()
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false
        chevronIcon.image = UIImage(named: "chevron")
        return chevronIcon
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
        setupMyOrdersLabelLayout()
        setupChevronIconLayout()
    }
    
    private func setupMyOrdersLabelLayout() {
        addSubview(myOrdersLabel)
        
        myOrdersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        myOrdersLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        myOrdersLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupChevronIconLayout() {
        addSubview(chevronIcon)
        
        chevronIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        chevronIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        chevronIcon.heightAnchor.constraint(equalToConstant: 28).isActive = true
        chevronIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
    }
}
