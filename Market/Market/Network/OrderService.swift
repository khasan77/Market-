//
//  OrderService.swift
//  Market
//
//  Created by Хасан Магомедов on 10.02.2026.
//

import Foundation

final class OrderService {
    
    static let shared = OrderService()
    
    // Для локальной разработки на симуляторе http://localhost:8000
    // Для тестирования на реальном устройстве IP мака
    private let baseURL = "http://192.168.1.40:8000"
    
    // Создание заказа на сервере
    //   - customerName: Имя покупателя
    //   - customerPhone: Телефон покупателя
    //   - products: Массив продуктов из корзины
    //   - completion: Callback с результатом
    func createOrder(
        customerName: String,
        customerPhone: String,
        products: [Product],
        completion: @escaping (Result<ApiOrderResponse, NetworkServiceError>) -> Void
    ) {
        // Формируем URL
        guard let url = URL(string: "\(baseURL)/api/orders") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Преобразуем продукты в ApiOrderItem
        let items = products.enumerated().map { index, product in
            ApiOrderItem(
                productId: index + 1, // Используем индекс как ID
                productName: product.title,
                price: Double(product.price) ?? 1.0,
                quantity: 1 // По умолчанию количество = 1, можно сделать динамическим
            )
        }
        
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        
        // Создаём запрос
        let orderRequest = ApiOrderCreateRequest(
            userId: currentUserId > 0 ? currentUserId : nil,
            customerName: customerName,
            customerPhone: customerPhone,
            customerEmail: nil,
            deliveryAddress: nil,
            items: items,
            comment: nil
        )
        
        // Настраиваем URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Сериализуем данные в JSON
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(orderRequest)
        } catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        // Отправляем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем ошибку сети
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Проверяем HTTP статус
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    // Пытаемся получить сообщение об ошибке от сервера
                    if let data = data,
                       let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                       let detail = errorMessage["detail"] {
                        completion(.failure(.serverError(detail)))
                    } else {
                        completion(.failure(.serverError("Статус код: \(httpResponse.statusCode)")))
                    }
                    return
                }
            }
            
            // Проверяем наличие данных
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Декодируем ответ
            do {
                let decoder = JSONDecoder()
                let orderResponse = try decoder.decode(ApiOrderResponse.self, from: data)
                completion(.success(orderResponse))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    // Получение заказов текущего пользователя
    func fetchOrders(
        completion: @escaping (Result<[ApiOrderResponse], NetworkServiceError>) -> Void
    ) {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        let urlString = userId > 0
            ? "\(baseURL)/api/orders/user/\(userId)"
            : "\(baseURL)/api/orders"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let orders = try JSONDecoder().decode([ApiOrderResponse].self, from: data)
                completion(.success(orders))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    // Получение заказа по ID
    func fetchOrder(
        by id: Int,
        completion: @escaping (Result<ApiOrderResponse, NetworkServiceError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/orders/\(id)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let order = try JSONDecoder().decode(ApiOrderResponse.self, from: data)
                completion(.success(order))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
