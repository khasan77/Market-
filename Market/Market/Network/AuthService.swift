//
//  AuthService.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

final class AuthService {
    
    static let shared = AuthService()
    
    // Для симулятора: http://localhost:8000
    // Для реального устройства: http://192.168.X.X:8000
    private let baseURL = "http://192.168.1.40:8000"
    
    private init() {}
    
    // Регистрация нового пользователя
    func register(
        name: String,
        phone: String,
        password: String,
        completion: @escaping (Result<ApiUserResponse, NetworkServiceError>) -> Void
    ) {
        // 1. Формируем URL
        guard let url = URL(string: "\(baseURL)/api/register") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // 2. Создаём запрос
        let registerRequest = ApiUserRegisterRequest(
            customerName: name,
            customerPhone: phone,
            password: password
        )
        
        // 3. Настраиваем URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 4. Сериализуем данные в JSON
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(registerRequest)
        } catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        // 5. Отправляем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем ошибку сети
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Проверяем HTTP статус
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let data = data,
                       let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                        let message = Self.humanReadableMessage(from: errorResponse)
                        completion(.failure(.serverError(message)))
                    } else {
                        completion(.failure(.serverError("Ошибка сервера (\(httpResponse.statusCode))")))
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
                let userResponse = try decoder.decode(ApiUserResponse.self, from: data)
                completion(.success(userResponse))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func login(
        phone: String,
        password: String,
        completion: @escaping (Result<ApiUserResponse, NetworkServiceError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let loginRequest = ApiUserLoginRequest(customerPhone: phone, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let data = data,
                       let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                        let message = Self.humanReadableMessage(from: errorResponse)
                        completion(.failure(.serverError(message)))
                    } else {
                        completion(.failure(.serverError("Ошибка сервера (\(httpResponse.statusCode))")))
                    }
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let userResponse = try JSONDecoder().decode(ApiUserResponse.self, from: data)
                completion(.success(userResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    private static func humanReadableMessage(from error: ApiErrorResponse) -> String {
        switch error.errorCode {
        case "user_already_exists":
            return "Данный пользователь уже зарегистрирован"
        case "phone_already_exists":
            return "Данный номер телефона уже зарегистрирован"
        case "invalid_credentials":
            return "Неверный номер телефона или пароль"
        default:
            return error.errorMessage ?? "Ошибка"
        }
    }
}
