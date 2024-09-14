//
//  Product.swift
//  Market
//
//  Created by Хасан Магомедов on 27.09.2023.
//

final class Product {
    let image: String
    let title: String
    let price: String
    let features: [Feature]?
    
    init(image: String, title: String, price: String = "500", features: [Feature]? = nil) {
        self.image = image
        self.title = title
        self.price = price
        self.features = features
    }
}
