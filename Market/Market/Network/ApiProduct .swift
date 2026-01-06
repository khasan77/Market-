//
//  ApiProduct .swift
//  Market
//
//  Created by Хасан Магомедов on 06.01.2026.
//

import Foundation

struct ApiProductResponse: Codable {
    let products: [ApiProduct]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ApiProduct: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
}
