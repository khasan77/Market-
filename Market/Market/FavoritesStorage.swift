//
//  FavoritesStorage.swift
//  Market
//
//  Created by Хасан Магомедов on 08.10.2023.
//

final class FavoritesStorage {
    
    static let shared = FavoritesStorage()
    
    var items: [Product] = []
    
    private init() {}
}
