//
//  Item.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/21/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

public enum ItemType: String {
    case comics
    case events
    case series
    case stories
}

struct Item {
    
    let title: String
    let fullDescription: String
    var imageUrlString: String = ""
    
    init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let fullDescription = json["description"] as? String,
            let thumbnail = json["thumbnail"] as? [String: String] else {
                return nil
        }
        
        self.title = title
        self.fullDescription = fullDescription
        if let path = thumbnail["path"], let imageExtension = thumbnail["extension"] {
            imageUrlString = assembleUrlForImageWith(path: path, imageExtension: imageExtension)
        }
    }
    
    
    private func assembleUrlForImageWith(path: String, imageExtension: String) -> String {
        return "\(path).\(imageExtension)"
    }
}




