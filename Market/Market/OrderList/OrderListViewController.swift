//
//  OrderListViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 17.10.2023.
//

import UIKit

final class OrderListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        title = "Мои заказы"
        
        setupLayout()
        
        tableView.dataSource = self
        tableView.delegate = self
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
        
        tableView.register(OrderListTableViewCell.self, forCellReuseIdentifier: OrderListTableViewCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension OrderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        OrderStorage.shared.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderListTableViewCell.identifier, for: indexPath) as? OrderListTableViewCell else {
            fatalError("Can not dequeue CustomTableViewCell")
        }
        let order = OrderStorage.shared.orders[indexPath.row]
        cell.configure(order: order)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OrderListViewController: UITableViewDelegate {}
