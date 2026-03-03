//
//  ApiUserRegisterRequest.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

// Модель для входа (отправляется на сервер)
struct ApiUserLoginRequest: Codable {
    let customerPhone: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case customerPhone = "customer_phone"
        case password
    }
}

// Модель для регистрации пользователя (отправляется на сервер)
struct ApiUserRegisterRequest: Codable {
    let customerName: String
    let customerPhone: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case password
    }
}
