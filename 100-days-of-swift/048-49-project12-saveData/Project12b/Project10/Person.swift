//
//  Person.swift
//  Project10
//
//  Created by Daniel Sasse on 1/12/22.
//

import UIKit

class Person: NSObject, Codable {
    // NSObject is the base of all UIKit objects. Not required, but provides access to ObjC methods
    
    var name: String
    var imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}
