//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 11..
//

import Foundation

public struct TorrentContent: Decodable {
    enum CodingKeys: String, CodingKey {
        case availability
        case index
        case isSeed = "is_seed"
        case name
        case pieceRange = "piece_range"
        case priority
        case progress
        case size
    }
    
    public enum Priority: Int, Decodable {
        case doNotDownload = 0
        case normal = 1 // 4
        case high = 6
        case maximum = 7
        
        init?(from raw: Int) {
            if raw == 4 {
                self = .normal
                return
            }
            
            guard let parsed = Priority(rawValue: raw) else { return nil }
            self = parsed
        }
    }
    
    
    public let name: String
    public let index: Int
    public let size: Int64
    public let isSeed: Bool
    public let progress: Float
    public let priority: Priority
    public let availability: Float
    public let pieceRange: [Int]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.index = try container.decode(Int.self, forKey: .index)
        self.size = try container.decode(Int64.self, forKey: .size)
        self.isSeed = try container.decodeIfPresent(Bool.self, forKey: .isSeed) ?? false
        self.progress = try container.decode(Float.self, forKey: .progress)
        let rawPriority = try container.decode(Int.self, forKey: .priority)
        guard let priority = Priority(from: rawPriority) else {
            throw Swift.DecodingError.typeMismatch(Priority.self, DecodingError.Context(codingPath: [CodingKeys.priority], debugDescription: "Raw value was: \(rawPriority)", underlyingError: nil))
        }
        self.priority = priority
        self.availability = try container.decode(Float.self, forKey: .availability)
        self.pieceRange = try container.decode([Int].self, forKey: .pieceRange)
    }
}
