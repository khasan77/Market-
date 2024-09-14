//
//  ProductsListViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 27.09.2023.
//

import UIKit

final class ProductsListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 12 - 32) / 4, height: 200)
        collectionViewFlowLayout.minimumInteritemSpacing = 4
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Private properties
    
    private let sections = [
        ProductSection(
            title: "Популярное",
            items: [
                Product(image: "luke", title: "The"),
                Product(image: "luke", title: "most"),
                Product(image: "luke", title: "powerful"),
                Product(image: "luke", title: "Jedi")
            ]
        ),
        ProductSection(
            title: "Хиты продаж",
            items: [
                Product(image: "luke", title: "The"),
                Product(image: "luke", title: "most"),
                Product(image: "luke", title: "powerful"),
                Product(image: "luke", title: "Jedi")
            ]
        ),
        ProductSection(
            title: "Распродажа",
            items: [
                Product(image: "luke", title: "The"),
                Product(image: "luke", title: "most"),
                Product(image: "luke", title: "powerful"),
                Product(image: "luke", title: "Jedi")
            ]
        )
    ]
    
    // MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Главная"
        
        view.backgroundColor = .white
        
        setupCollectionViewLayout()
        
        collectionView.dataSource = self
    }
    
    // MARK: - Private methods
    
    private func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        collectionView.register(ProductSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductSectionHeaderView.identifier)
    }
    
    func headerActionButtonTapped(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        let section = sections[indexPath.section]
        
        let vc = CategoryListViewController(items: section.items)
        vc.title = section.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell else {
            fatalError("something went wrong!")
        }
        let item = sections[indexPath.section].items[indexPath.item]
        cell.configure(item: item)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductSectionHeaderView.identifier, for: indexPath) as? ProductSectionHeaderView else {
            fatalError("Can not dequeue ProductSectionHeaderView")
        }
        let title = sections[indexPath.section].title
        header.configure(title: title)
        header.indexPath = indexPath
        header.delegate = self
        
        
        return header
    }
}

