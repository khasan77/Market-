//
//  ProductsSectionProvider.swift
//  Market
//
//  Created by Хасан Магомедов on 29.09.2023.
//

struct ProductsSectionProvider {
    
//    static func makeSections() -> [ProductSection] {
//        [
//            ProductSection(
//                title: "Популярное",
//                items: [
//                    Product(image: "luke", title: "Первый 1", features: [
//                            Feature(title: "Экран", description: "")     
//                    ]),
//                    Product(image: "luke", title: "Второй 2"),
//                    Product(image: "luke", title: "Третий 3"),
//                    Product(image: "luke", title: "Четвертый 4"),
//                    Product(image: "luke", title: "Пятый 1"),
//                    Product(image: "luke", title: "Шестой 2"),
//                    Product(image: "luke", title: "Седьмой 3"),
//                    Product(image: "luke", title: "Восьмой 4")
//                ]
//            ),
//            ProductSection(
//                title: "Хиты продаж",
//                items: [
//                    Product(image: "luke", title: "Хиты продаж 1"),
//                    Product(image: "luke", title: "Хиты продаж 2"),
//                    Product(image: "luke", title: "Хиты продаж 3"),
//                    Product(image: "luke", title: "Хиты продаж 4"),
//                    Product(image: "luke", title: "Хиты продаж 1"),
//                    Product(image: "luke", title: "Хиты продаж 2"),
//                    Product(image: "luke", title: "Хиты продаж 3"),
//                    Product(image: "luke", title: "Хиты продаж 4")
//                ]
//            ),
//            ProductSection(
//                title: "Распродажа",
//                items: [
//                    Product(image: "luke", title: "Распродажа 1"),
//                    Product(image: "luke", title: "Распродажа 2"),
//                    Product(image: "luke", title: "Распродажа 3"),
//                    Product(image: "luke", title: "Распродажа 4"),
//                    Product(image: "luke", title: "Распродажа 1"),
//                    Product(image: "luke", title: "Распродажа 2"),
//                    Product(image: "luke", title: "Распродажа 3"),
//                    Product(image: "luke", title: "Распродажа 4")
//                ]
//            )
//        ]
//    }
    
    static func makeSections(completion: @escaping ([ProductSection]) -> Void) {
        // Map API categories to section titles
        let categoryMapping: [String: String] = [
            "laptops": "Популярное",
            "smartphones": "Хиты продаж",
            "tablets": "Распродажа"
        ]
        
        let categories = ["laptops", "smartphones", "tablets"]
        
        ProductService.shared.fetchProductsByCategories(
            categories: categories,
            limitPerCategory: 8
        ) { productsByCategory in
            var sections: [ProductSection] = []
            
            for category in categories {
                if let products = productsByCategory[category],
                   let sectionTitle = categoryMapping[category] {
                    let mappedProducts = ProductMapper.map(products)
                    sections.append(ProductSection(title: sectionTitle, items: mappedProducts))
                }
            }
            
            let finalSections = sections.isEmpty ? fallbackSections() : sections
            completion(finalSections)
        }
    }
    
    private static func fallbackSections() -> [ProductSection] {
        // Fallback to empty sections if API fails
        return [
            ProductSection(title: "Популярное", items: []),
            ProductSection(title: "Хиты продаж", items: []),
            ProductSection(title: "Распродажа", items: [])
        ]
    }
}
