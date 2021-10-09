//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation

public struct TorrentInfo: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case state = "state"
        case hash = "hash"
        case category = "category"
        case tags = "tags"
        case progress = "progress"
    }
    
    public let name: String
    public let state: String
    public let hash: String
    public let category: String
    public let tags: [String]
    public let progress: Float
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.state = try container.decode(String.self, forKey: .state)
        self.hash = try container.decode(String.self, forKey: .hash)
        self.category = try container.decode(String.self, forKey: .category)
        
        let rawTags = try container.decode(String.self, forKey: .tags)
        self.tags = rawTags.split(separator: ",").map { String($0) }
        self.progress = try container.decode(Float.self, forKey: .progress)
    }
}
