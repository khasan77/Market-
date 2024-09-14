//  ProductsTableViewCell.swift
//  Market
//  Created by Хасан Магомедов on 28.09.2023.

import UIKit

protocol ProductsTableViewCellDelegate: AnyObject {
    func didSelectItem(_ item: Product)
}

final class ProductsTableViewCell: UITableViewCell {
    
    static let identifier = "ProductsTableViewCell"
    
    weak var delegate: ProductsTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40) / 3, height: 200)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private var items: [Product] = []
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        contentView.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
    }
    
    func configure(items: [Product]) {
        self.items = items
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell else {
            fatalError("Can not dequeue ProductsCollectionViewCell")
        }
        let item = items[indexPath.item]
        cell.configure(item: item)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        delegate?.didSelectItem(item)
    }
}

// MARK: - ProductCollectionViewCellDelegate

extension ProductsTableViewCell: ProductCollectionViewCellDelegate {
    
    func likeButtonTapped(cell: ProductsCollectionViewCell, isSelected: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let item = items[indexPath.item]
        
        if isSelected {
            FavoritesStorage.shared.items.append(item)
        } else {
            FavoritesStorage.shared.items.removeAll {$0 === item }
        }
        
        NotificationCenter.default.post(name: Notifications.favoritesChanged, object: nil)
    }
}
