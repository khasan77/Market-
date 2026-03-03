//  OrderListTableViewCell.swift
//  Market
//  Created by Хасан Магомедов on 17.10.2023.

import UIKit

final class OrderListTableViewCell: UITableViewCell {
    
    static let identifier = "OrderListTableViewCell"
    
    // MARK: - UI Elements
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let productsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupPriceLabelLayout()
        setupProductsCountLabelLayout()
        setupStatusLabelLayout()
        setupOrderNumberLabelLayout()
    }
    
    // MARK: - Private methods
    
    private func setupPriceLabelLayout() {
        contentView.addSubview(priceLabel)
        
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
    }
    
    private func setupProductsCountLabelLayout() {
        contentView.addSubview(productsCountLabel)
        
        productsCountLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        productsCountLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    private func setupStatusLabelLayout() {
        contentView.addSubview(statusLabel)
        
        statusLabel.leadingAnchor.constraint(equalTo: productsCountLabel.leadingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: productsCountLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    private func setupOrderNumberLabelLayout() {
        contentView.addSubview(orderNumberLabel)
        
        orderNumberLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor).isActive = true
        orderNumberLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4).isActive = true
        orderNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func configure(order: ApiOrderResponse) {
        priceLabel.text = "Сумма заказа: \(order.totalAmount)"
        productsCountLabel.text = "Количество позиций: \(order.items.count)"
        statusLabel.text = order.status.displayName
        orderNumberLabel.text = "Номер заказа: \(order.orderNumber)"
    }
}
