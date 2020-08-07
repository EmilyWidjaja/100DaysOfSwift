//
//  Person.swift
//  Project10
//
//  Created by Emily Widjaja on 14/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
