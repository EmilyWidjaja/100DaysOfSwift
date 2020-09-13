//
//  Extensions.swift
//  hiit IT
//
//  Created by Emily Widjaja on 9/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
