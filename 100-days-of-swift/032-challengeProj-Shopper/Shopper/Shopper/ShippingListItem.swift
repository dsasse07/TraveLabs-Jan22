//
//  ShippingListItem.swift
//  Shopper
//
//  Created by Daniel Sasse on 1/7/22.
//

import Foundation

class ShoppingListItem {
    var itemName: String
    var quantity: Int = 1
    var isDone: Bool = false
    
    init(item itemName: String, amount quantity: Int){
        self.itemName = itemName
        self.quantity = quantity
    }
}
