//
//  Notifications.swift
//  Market
//
//  Created by Хасан Магомедов on 08.10.2023.
//

import Foundation

struct Notifications {
    static let favoritesChanged = NSNotification.Name("favoriteListChanged")
    static let orderConfirmed = NSNotification.Name("deletedItemFromFavorites")
}
