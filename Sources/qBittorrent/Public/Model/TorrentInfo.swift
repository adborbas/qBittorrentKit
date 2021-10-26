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
        case addedDate = "added_on"
        case completionDate = "completion_on"
        case downloaded = "downloaded"
        case amountLeft = "amount_left"
        case eta = "eta"
        case ratio = "ratio"
        case size = "size"
        case totalSize = "total_size"
        case uploadSpeed = "upspeed"
        case downloadSpeed = "dlspeed"
    }
    
    public let name: String
    public let state: String
    public let hash: String
    public let category: String
    public let tags: [String]
    public let progress: Float
    public let addedDate: Date
    public let completionDate: Date
    public let amountLeft: Int64
    public let downloaded: Int64
    public let eta: Int
    public let ratio: Float
    public let size: Int64
    public let totalSize: Int64
    public let uploadSpeed: Int64
    public let downloadSpeed: Int64
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.state = try container.decode(String.self, forKey: .state)
        self.hash = try container.decode(String.self, forKey: .hash)
        self.category = try container.decode(String.self, forKey: .category)
        
        let rawTags = try container.decode(String.self, forKey: .tags)
        self.tags = rawTags.split(separator: ",").map { String($0) }
        
        self.progress = try container.decode(Float.self, forKey: .progress)
        
        let rowAddedDate = try container.decode(Int.self, forKey: .addedDate)
        self.addedDate = Date(timeIntervalSince1970: TimeInterval(rowAddedDate))
        let rowCompletionDate = try container.decode(Int.self, forKey: .completionDate)
        self.completionDate = Date(timeIntervalSince1970: TimeInterval(rowCompletionDate))
        self.amountLeft = try container.decode(Int64.self, forKey: .amountLeft)
        self.downloaded = try container.decode(Int64.self, forKey: .downloaded)
        self.eta = try container.decode(Int.self, forKey: .eta)
        self.ratio = try container.decode(Float.self, forKey: .ratio)
        self.size = try container.decode(Int64.self, forKey: .size)
        self.totalSize = try container.decode(Int64.self, forKey: .totalSize)
        self.uploadSpeed = try container.decode(Int64.self, forKey: .uploadSpeed)
        self.downloadSpeed = try container.decode(Int64.self, forKey: .downloadSpeed)
    }
}
