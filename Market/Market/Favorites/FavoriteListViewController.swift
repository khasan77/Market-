//
//  FavoriteListViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 05.10.2023.
//

import UIKit

final class FavoriteListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти к оформлению", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let items = [
        Product(image: "luke", title: "Распродажа 2"),
        Product(image: "luke", title: "Распродажа 3"),
        Product(image: "luke", title: "Распродажа 4")
    ]
    
    // MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Избранное"
        
        setupLayout()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupTableViewLayout()
        setupNotificationCenter()
        setupButtonLayout()
        updateButtonVisibility()
    }
    
    // MARK: - Private methods
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(FavoriteListTableViewCell.self, forCellReuseIdentifier: FavoriteListTableViewCell.identifier)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteListChanged), name: Notifications.favoritesChanged, object: nil)
    }
    
    @objc
    private func favoriteListChanged() {
        guard view.window == nil else { return }
        
        tableView.reloadData()
        updateButtonVisibility()
    }
    
    private func setupButtonLayout() {
        view.addSubview(button)
        
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchDown)
    }
    
    private func updateButtonVisibility() {
        if FavoritesStorage.shared.items.isEmpty {
            button.isEnabled = false
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        } else {
            button.isEnabled = true
            button.backgroundColor = .systemBlue
        }
    }
    
    @objc
    private func confirmButtonTapped() {
        let vc = OrderConfirmationViewController(items: FavoritesStorage.shared.items)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleDelete(indexPath: IndexPath) {
        FavoritesStorage.shared.items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        updateButtonVisibility()
        
        NotificationCenter.default.post(name: Notifications.favoritesChanged, object: nil)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoritesStorage.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteListTableViewCell.identifier, for: indexPath) as? FavoriteListTableViewCell else {
            fatalError("Can not dequeue FavoriteListTableViewCell")
        }
        cell.configure(item: FavoritesStorage.shared.items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
            self?.handleDelete(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
