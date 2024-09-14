//
//  OrderConfirmationViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 11.10.2023.
//

import UIKit

final class OrderConfirmationViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = OrderConfirmationView()
    
    private let items: [Product]
    
    private var price = 0
    
    // MARK: - Init
    
    init(items: [Product]) {
        self.items = items
        
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfe Cycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        title = "Оформление заказа"
        
        mainView.dataSource = self
        mainView.delegate = self
        
        calculatePrice()
    }
    
    // MARK: - Private methods
    
    private func calculatePrice() {
        var price = 0
        
        for item in items {
            price += Int(item.price) ?? 0
        }
        
        mainView.price = String(price)
        
        self.price = price
    }
}

// MARK: - OrderConfirmationViewDelegate

extension OrderConfirmationViewController: OrderConfirmationViewDelegate {
    
    func confirmButtonTapped() {
        let order = Order(price: String(price), products: items)
        OrderStorage.shared.orders.append(order)
        
        let alert = UIAlertController(title: "Оформление заказа", message: "Спасибо! Ваш заказ оформлен", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ок", style: .default) { [weak self] _ in
            FavoritesStorage.shared.items = []
            
            self?.navigationController?.popViewController(animated: true)
    
            NotificationCenter.default.post(name: Notifications.favoritesChanged, object: nil)
            
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension OrderConfirmationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
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

extension OrderConfirmationViewController: UITableViewDelegate {}
