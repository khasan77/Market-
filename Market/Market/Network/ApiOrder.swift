//
//  ApiOrder.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

// Модель товара для отправки в заказе
struct ApiOrderItem: Codable {
    let productId: Int
    let productName: String
    let price: Double
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productName = "product_name"
        case price
        case quantity
    }
}

// Статус заказа
enum ApiOrderStatus: String, Codable {
    case pending = "pending"
    case confirmed = "confirmed"
    case shipped = "shipped"
    case delivered = "delivered"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .pending: return "Ожидает обработки"
        case .confirmed: return "Подтверждён"
        case .shipped: return "Отправлен"
        case .delivered: return "Доставлен"
        case .cancelled: return "Отменён"
        }
    }
}
