//
//  File.swift
//  Market
//
//  Created by Хасан Магомедов on 17.10.2023.
//

final class OrderStorage {
    
    static let shared = OrderStorage()
    
    var orders: [Order] = []
    
    private init() {}
}

