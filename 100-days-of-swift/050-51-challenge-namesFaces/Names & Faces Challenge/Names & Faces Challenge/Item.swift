//
//  Item.swift
//  Names & Faces Challenge
//
//  Created by Daniel Sasse on 1/13/22.
//

import Foundation

class Item: NSObject, Codable {
    var itemName: String
    var imageName: String
    
    init(itemName: String, imageName: String){
        self.itemName = itemName
        self.imageName = imageName
    }
}
