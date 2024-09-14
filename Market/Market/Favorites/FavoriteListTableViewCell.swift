//
//  FavoriteListTableViewCell.swift
//  Market
//
//  Created by Хасан Магомедов on 05.10.2023.
//

import UIKit

final class FavoriteListTableViewCell: UITableViewCell {
    
    static let identifier = "FavoriteListTableViewCell"
    
    // MARK: - UI Elements
    
    private let productImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
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
        productImageViewLayout()
        productTitleLayout()
    }
    
    // MARK: - Private methods
    
    private func productImageViewLayout() {
        contentView.addSubview(productImageView)
        
        productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 88).isActive = true
    }
    
    private func productTitleLayout() {
        contentView.addSubview(productTitle)
        
        productTitle.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        productTitle.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor).isActive = true
    }
    
    func configure(item: Product) {
        productImageView.image = UIImage(named: item.image)
        productTitle.text = item.title
    }
}
