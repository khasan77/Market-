//
//  ApiOrderCreateRequest.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

// Модель для создания заказа (отправляется на сервер)
struct ApiOrderCreateRequest: Codable {
    let userId: Int?
    let customerName: String
    let customerPhone: String
    let customerEmail: String?
    let deliveryAddress: String?
    let items: [ApiOrderItem]
    let comment: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case customerEmail = "customer_email"
        case deliveryAddress = "delivery_address"
        case items
        case comment
    }
}
