//  NewProductsViewController.swift
//  Market
//  Created by Хасан Магомедов on 28.09.2023.

import UIKit

final class ProductListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 240
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        return tableView
    }()
    
    // MARK: - Private properties
    
    private let storedSections = ProductsSectionProvider.makeSections()
    
    private var searchResultSection: ProductSection?
    
    private var isSearching = false
    
    private var sections: [ProductSection] {
        if let searchResultSection = searchResultSection {
            return [searchResultSection]
        }
        
        if isSearching {
            return []
        }
        
        return storedSections
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Товары"
        
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.placeholder = "Поиск"
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.delegate = self
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesChanged), name: Notifications.favoritesChanged, object: nil)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupTableViewLayout()
    }
    
    // MARK: - Private methods
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: ProductsTableViewCell.identifier)
    }
    
    @objc
    private func favoritesChanged() {
        guard view.window == nil else { return }
        
        tableView.reloadData()
    }
    
    func headerActionButtonTapped(index: Int?) {
        guard let index = index else { return }
        
        let section = sections[index]
        
        let vc = CategoryListViewController(items: section.items)
        vc.title = section.title
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ProductListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as? ProductsTableViewCell else {
            fatalError("Can not dequeue ProductsTableViewCell")
        }
        let section = sections[indexPath.section]
        cell.configure(items: section.items)
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let productsSection = sections[section]
        let view = ProductsSectionHeaderView()
        view.delegate = self
        view.sectionIndex = section
        view.configure(title: productsSection.title)
        return view
    }
}

// MARK: - UISearchResultsUpdating

extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let allItems = storedSections.flatMap { $0.items }
        
        let filteredItems = allItems.filter { item in
            item.title.lowercased().contains(text.lowercased())
        }
        
        if !filteredItems.isEmpty {
            searchResultSection = ProductSection(title: "Результат поиска", items: filteredItems)
        } else {
            searchResultSection = nil
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension ProductListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultSection = nil
        
        tableView.reloadData()
    }
}

// MARK: - ProductsTableViewCellDelegate

extension ProductListViewController: ProductsTableViewCellDelegate {
    
    func didSelectItem(_ item: Product) {
        let vc = ProductInfoViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
