//
//  Image.swift
//  PhotoGallery(Consolidation5)
//
//  Created by Emily Widjaja on 15/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class Image: NSObject {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }

}
