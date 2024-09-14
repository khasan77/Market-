//
//  Order.swift
//  Market
//
//  Created by Хасан Магомедов on 17.10.2023.
//

struct Order {
    
    enum Status: String {
        case initial = "Заказ создан"
        case setup = "Заказ собран"
        case delivery = "Заказ в пути"
    }
    
    let price: String
    let products: [Product]
    let status: Status = .initial
}
