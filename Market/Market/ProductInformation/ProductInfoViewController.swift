//
//  ProductInfoViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 09.10.2023.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        //tableView.rowHeight = 28
        return tableView
    }()
    
    // MARK: - Private properties
    
    private let item: Product
    
    // MARK: - Init
    
    init(item: Product) {
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        
        tableView.dataSource = self
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        setupNavigationItems()
        setupTitleLabelLayout()
        setupTableViewLayout()
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(likeButtonTapped))
    }
    
    @objc
    private func likeButtonTapped() {}
    
    private func setupTitleLabelLayout() {
        view.addSubview(titleLabel)
        
        titleLabel.text = item.title
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(FeaturesTableViewCell.self, forCellReuseIdentifier: FeaturesTableViewCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension ProductInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item.features?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.identifier, for: indexPath) as? FeaturesTableViewCell else {
            fatalError("Can not deqeue FeaturesTableViewCell")
        }
        cell.selectionStyle = .none
        guard let item = item.features?[indexPath.item] else {
            fatalError("Item can not be nil")
        }
        cell.configure(item: item)
        return cell
    }
}
