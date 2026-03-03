//
//  ApiOrderResponce.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

// Ответ после создания заказа
struct ApiOrderResponse: Codable {
    let orderId: Int
    let orderNumber: String
    let userId: Int?
    let customerName: String
    let customerPhone: String
    let customerEmail: String?
    let deliveryAddress: String?
    let items: [ApiOrderItem]
    let totalAmount: Double
    let status: ApiOrderStatus
    let comment: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderNumber = "order_number"
        case userId = "user_id"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case customerEmail = "customer_email"
        case deliveryAddress = "delivery_address"
        case items
        case totalAmount = "total_amount"
        case status
        case comment
        case createdAt = "created_at"
    }
}

