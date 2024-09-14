//
//  ProductSectionHeaderView.swift
//  Market
//
//  Created by Хасан Магомедов on 28.09.2023.
//

import UIKit

final class ProductsSectionHeaderView: UIView {
    
    weak var delegate: ProductListViewController?
    
    var sectionIndex: Int?
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Заголовок"
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать все", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupTitleLabellayout()
        setupActionButtonLayout()
    }
    
    // MARK: - Private methods
    
    private func setupTitleLabellayout() {
        addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupActionButtonLayout() {
        addSubview(actionButton)
        
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchDown)
    }
    
    @objc
    private func actionButtonTapped() {
        delegate?.headerActionButtonTapped(index: sectionIndex)
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

