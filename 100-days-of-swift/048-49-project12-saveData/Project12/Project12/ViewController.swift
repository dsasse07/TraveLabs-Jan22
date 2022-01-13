//
//  ViewController.swift
//  Project12
//
//  Created by Daniel Sasse on 1/13/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We can save any time to a key of type string to UserDefaults
        // Value must be Int, Float, Double, String, Boolean, Array, Dictionary
        // or it can be a Class that conforms to NSCoding
        // Most Apple classes conform to NSCoding by default
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set("Danny", forKey: "Name")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "Array")
        
        let dict = [
            "Name": "Danny",
            "Country":"UK"
        ]
        defaults.set(dict, forKey: "Dictionary")
        
        
        
        
        let savedInt = defaults.integer(forKey: "Age") // age or 0
        let savedBoolean = defaults.bool(forKey: "UseFaceId") // result or default of false
        
        // Gets the array and casts it to [String].
        // If key doesnt exist, or value cannot be cast, creates a new array
        let savedArray = defaults.object(forKey: "Array") as? [String] ?? [String]()
        let savedDict = defaults.object(forKey: "Dictionary") as? [String:String] ?? [String:String]()
        
    }


}

