//
//  ProductSection.swift
//  Market
//
//  Created by Хасан Магомедов on 28.09.2023.
//

struct ProductSection: Equatable {
    let title: String
    let items: [Product]
    
    static func == (lhs: ProductSection, rhs: ProductSection) -> Bool {
        return lhs.title == rhs.title && lhs.items.count == rhs.items.count
    }
}
