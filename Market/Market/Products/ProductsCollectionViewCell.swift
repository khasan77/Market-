//
//  ProductsCollectionViewCell.swift
//  Market
//
//  Created by Хасан Магомедов on 27.09.2023.
//

import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func likeButtonTapped(cell: ProductsCollectionViewCell, isSelected: Bool)
}

final class ProductsCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    static let identifier = "ProductsCollectionViewCell"
    
    // MARK: - UI Elements
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "luke")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupImageViewLayout()
        setupTitleLabelLayout()
        setupLikeButtonLayout()
    }
    
    // MARK: - Private methods
    
    private func setupImageViewLayout() {
        contentView.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    private func setupTitleLabelLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true 
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupLikeButtonLayout() {
        contentView.addSubview(likeButton)
        
        likeButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchDown)
    }
    
    @objc
    private func likeButtonTapped() {
        likeButton.isSelected = !likeButton.isSelected
        
        updateLikeButton(isSelected: likeButton.isSelected)
        
        delegate?.likeButtonTapped(cell: self, isSelected: likeButton.isSelected)
    }
    
    private func updateLikeButton(isSelected: Bool) {
        if isSelected {
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .red
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }
    }
    
    func configure(item: Product) {
        imageView.image = UIImage(named: item.image)
        titleLabel.text = item.title
        let isLiked = FavoritesStorage.shared.items.contains { $0 === item }
        updateLikeButton(isSelected: isLiked)
    }
}

// MARK: - ProductCollectionViewCellDelegate

extension ProductsListViewController: ProductCollectionViewCellDelegate {
    
    func likeButtonTapped(cell: ProductsCollectionViewCell, isSelected: Bool) {}
    
}
