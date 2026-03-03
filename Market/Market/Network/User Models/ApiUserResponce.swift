//
//  ApiUserResponce.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

// Модель ответа после успешной регистрации
struct ApiUserResponse: Codable {
    let userId: Int
    let customerName: String
    let customerPhone: String
    let customerEmail: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case customerEmail = "customer_email"
        case createdAt = "created_at"
    }
}
