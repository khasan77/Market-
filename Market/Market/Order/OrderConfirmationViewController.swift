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
    
    private var items: [Product]
    
    private var price = 0
    
    private var orderService = OrderService.shared
    
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
    
    private func showAlert(title: String = "Внимание", message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func createOrder(name: String, phone: String) {
        // Показываем индикатор загрузки
        //activityIndicator.startAnimating()
        mainView.confirmButton.isEnabled = false
        
        // Отправляем заказ через OrderService
        OrderService.shared.createOrder(
            customerName: name,
            customerPhone: phone,
            products: items
        ) { [weak self] result in
            // Обработка выполняется в фоновом потоке,
            // поэтому UI обновления делаем в главном потоке
            DispatchQueue.main.async {
                //self?.activityIndicator.stopAnimating()
                self?.mainView.confirmButton.isEnabled = true
                
                switch result {
                case .success(let orderResponse):
                    // Заказ успешно создан!
                    self?.handleSuccessfulOrder(orderResponse)
                    
                case .failure(let error):
                    // Произошла ошибка
                    self?.handleOrderError(error)
                }
            }
        }
    }
    
    private func handleSuccessfulOrder(_ order: ApiOrderResponse) {
        print("✅ Заказ создан!")
        print("Номер заказа: \(order.orderNumber)")
        print("ID заказа: \(order.orderId)")
        print("Сумма: \(order.totalAmount)₽")
        print("Статус: \(order.status.displayName)")
        
        // Очищаем корзину
        OrderStorage.shared.orders.append(
            Order(
                price: "\(order.totalAmount)",
                products: items
            )
        )
        items.removeAll()
        
        // Показываем уведомление
        NotificationCenter.default.post(
            name: Notification.Name("OrderCreated"),
            object: nil
        )
        
        // Показываем Alert с номером заказа
        let alert = UIAlertController(
            title: "Заказ оформлен! ✅",
            message: """
                Номер вашего заказа: \(order.orderNumber)
                Сумма: \(order.totalAmount)₽
                
                Мы свяжемся с вами в ближайшее время!
                """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Возвращаемся на главный экран
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func handleOrderError(_ error: NetworkServiceError) {
        print("❌ Ошибка при создании заказа: \(error.localizedDescription)")
        
        // Показываем ошибку пользователю
        showAlert(
            title: "Ошибка",
            message: "Не удалось оформить заказ.\n\n\(error.localizedDescription)\n\nПопробуйте еще раз."
        )
    }
}

// MARK: - OrderConfirmationViewDelegate

extension OrderConfirmationViewController: OrderConfirmationViewDelegate {
    
    func confirmButtonTapped() {
        guard let name = mainView.nameTextField.text, !name.isEmpty else {
            showAlert(message: "Введите ваше имя")
            return
        }
        
        guard let phone = mainView.phoneNumberTextField.text, !phone.isEmpty else {
            showAlert(message: "Введите номер телефона")
            return
        }
        
        // Отправляем заказ
        createOrder(name: name, phone: phone)
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

// MARK: - UITextFieldDelegate
extension OrderConfirmationViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate

extension OrderConfirmationViewController: UITableViewDelegate {}
