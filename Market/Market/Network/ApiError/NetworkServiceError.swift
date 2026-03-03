//
//  OrderServiceError.swift
//  Market
//
//  Created by Хасан Магомедов on 12.02.2026.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(String)
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных"
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .serverError(let message):
            return "Ошибка сервера: \(message)"
        case .invalidResponse:
            return "Неверный ответ сервера"
        }
    }
}
