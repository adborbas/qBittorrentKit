//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 07..
//

import Foundation

public struct TorrentCategory: Codable, Hashable {
    public let name: String
    public let savePath: String
}

struct TorrentCategoryResponse : Codable {
    struct CategoryKey : CodingKey {
        var stringValue: String
        var intValue: Int? { return nil }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        var categories = [TorrentCategory]()
        
        let container = try decoder.container(keyedBy: CategoryKey.self)
        for key in container.allKeys {
            let category = try container.decode(TorrentCategory.self, forKey: key)
            categories.append(category)
        }
        
        self.categories = categories
    }
    
    let categories: [TorrentCategory]
}
