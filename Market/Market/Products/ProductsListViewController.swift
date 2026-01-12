//
//  ProductsListViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 27.09.2023.
//

import UIKit
import Combine

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
    
    private let viewModel = ProductsListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Главная"
        
        view.backgroundColor = .white
        
        setupCollectionViewLayout()
        
        collectionView.dataSource = self
        
        setupBindings()
        viewModel.loadProducts()
    }
    
    // MARK: - Private methods
    
    private func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collectionView.register(
            ProductsCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier
        )
        collectionView.register(
            ProductSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProductSectionHeaderView.identifier
        )
    }
    
    private func setupBindings() {
        // тут следим за изменениями в разделах, а removeDuplicates() убирает ненужные загрузки
        viewModel.$sections
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // состояние загрузки
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                print("Error: \(errorMessage)")
            }
            .store(in: &cancellables)
    }
    
    func headerActionButtonTapped(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        let section = viewModel.sections[indexPath.section]
        
        let vc = CategoryListViewController(items: section.items)
        vc.title = section.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell else {
            fatalError("something went wrong!")
        }
        let item = viewModel.sections[indexPath.section].items[indexPath.item]
        cell.configure(item: item)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductSectionHeaderView.identifier, for: indexPath) as? ProductSectionHeaderView else {
            fatalError("Can not dequeue ProductSectionHeaderView")
        }
        let title = viewModel.sections[indexPath.section].title
        header.configure(title: title)
        header.indexPath = indexPath
        header.delegate = self
        
        return header
    }
}

// MARK: - ProductCollectionViewCellDelegate

extension ProductsListViewController: ProductCollectionViewCellDelegate {
    
    func likeButtonTapped(cell: ProductsCollectionViewCell, isSelected: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let item = viewModel.sections[indexPath.section].items[indexPath.item]
        
        if isSelected {
            FavoritesStorage.shared.items.append(item)
        } else {
            FavoritesStorage.shared.items.removeAll { $0 === item }
        }
        
        NotificationCenter.default.post(name: Notifications.favoritesChanged, object: nil)
    }
}
