//
//  Person.swift
//  Project10
//
//  Created by Emily Widjaja on 14/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//  Using Codable, no need to specify read and write methods

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
