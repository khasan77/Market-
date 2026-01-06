//
//  ProductMapper.swift
//  Market
//
//  Created by Хасан Магомедов on 06.01.2026.
//

import Foundation

final class ProductMapper {
    
    static func map(_ apiProduct: ApiProduct) -> Product {
        
        let priceString = String(format: "%.0f", apiProduct.price)
        
        var features: [Feature] = []
        
        features.append(Feature(title: "Бренд", description: apiProduct.brand))
        features.append(Feature(title: "Категория", description: apiProduct.category))
        features.append(Feature(title: "Рейтинг", description: String(format: "%.1f", apiProduct.rating)))
        features.append(Feature(title: "Скидка", description: String(format: "%.0f%%", apiProduct.discountPercentage)))
        
        if apiProduct.stock > 0 {
            features.append(Feature(title: "В наличии", description: "\(apiProduct.stock) шт."))
        }
        
        let imageURL = apiProduct.thumbnail.isEmpty ? (apiProduct.images.first ?? "") : apiProduct.thumbnail
        
        return Product(
            image: "", 
            title: apiProduct.title,
            price: priceString,
            features: features.isEmpty ? nil : features,
            imageURL: imageURL
        )
    }
    
    static func map(_ apiProducts: [ApiProduct]) -> [Product] {
        return apiProducts.map { map($0) }
    }
}
