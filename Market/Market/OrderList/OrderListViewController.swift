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
    
    private var orders: [ApiOrderResponse] = []

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
        loadOrders()
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
    
    private func loadOrders() {
        OrderService.shared.fetchOrders { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    self?.orders = orders
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error loading orders: \(error)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension OrderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderListTableViewCell.identifier, for: indexPath) as? OrderListTableViewCell else {
            fatalError("Can not dequeue CustomTableViewCell")
        }
        let order = orders[indexPath.row]
        cell.configure(order: order)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OrderListViewController: UITableViewDelegate {}
