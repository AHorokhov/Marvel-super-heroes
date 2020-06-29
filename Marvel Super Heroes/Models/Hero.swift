//
//  Hero.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/15/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import Foundation

enum possibleImageResolutions: String {
    case portrait_incredible
    case standard_fantastic
    case landscape_incredible
}

struct Hero {
    
    // MARK: lets & vars
    
    let heroId: Int
    let name: String
    let fullDescription: String
    var portraitImageUrlString: String = ""
    var landscapeImageUrlString: String = ""

    var comicsURls: Array<String> = []
    var storiesURls: Array<String> = []
    var eventsURls: Array<String> = []
    var seriesURls: Array<String> = []
    
    enum CodingKeys : String, CodingKey {
        case heroId, name, fullDescription
    }
    
    
    // MARK: lifecycle
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let heroId = json["id"] as? Int,
            let fullDescription = json["description"] as? String,
            let thumbnail = json["thumbnail"] as? [String: String] else {
                return nil
        }
        self.heroId = heroId
        self.name = name
        self.fullDescription = fullDescription
        if let path = thumbnail["path"], let imageExtension = thumbnail["extension"] {
            self.portraitImageUrlString = assembleUrlForImageWith(path: path, imageExtension: imageExtension, resolution: possibleImageResolutions.portrait_incredible.rawValue)
            self.landscapeImageUrlString = assembleUrlForImageWith(path: path, imageExtension: imageExtension, resolution: possibleImageResolutions.landscape_incredible.rawValue)
        }
        comicsURls = parseItemsUrlsFor(json: json, type: "comics")
        seriesURls = parseItemsUrlsFor(json: json, type: "series")
        eventsURls = parseItemsUrlsFor(json: json, type: "events")
        storiesURls = parseItemsUrlsFor(json: json, type: "stories")
    }
    
    private func assembleUrlForImageWith(path: String, imageExtension: String, resolution: String) -> String {
        return "\(path)/\(resolution).\(imageExtension)"
    }
    
    private func parseItemsUrlsFor(json: [String: Any], type: String) -> [String] {
        if let comics = json[type] as? [String: Any],
            let items = comics["items"] as? [[String: String]] {
            return items.compactMap{ $0["resourceURI"] }
        }
        return []
    }
}
