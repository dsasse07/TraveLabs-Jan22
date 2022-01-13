//
//  Person.swift
//  Project10
//
//  Created by Daniel Sasse on 1/12/22.
//

import UIKit

class Person: NSObject, NSCoding {

    
    // NSObject is the base of all UIKit objects. Not required, but provides access to ObjC methods
    
    var name: String
    var imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
    
    // Comes from NSCoding - When decoded from disk, will use the init below. When encoding to disk, use encode method
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageName, forKey: "imageName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        imageName = aDecoder.decodeObject(forKey: "imageName") as? String ?? ""
    }
}
