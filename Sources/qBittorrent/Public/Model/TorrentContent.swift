//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 11..
//

import Foundation

// Torrent content.
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
    
    /// File priority.
    public enum Priority: Int, Decodable {
        
        /// Do not download.
        case doNotDownload = 0
        
        /// Normal priority.
        case normal = 1 // 4
        
        /// High priority.
        case high = 6
        
        /// Maximal priority
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
    
    /// File name (including relative path).
    public let name: String
    
    /// File index.
    public let index: Int
    
    /// File size (bytes).
    public let size: Int64
    
    /// True if file is seeding/complete.
    public let isSeed: Bool
    
    /// File progress (percentage/100).
    public let progress: Float
    
    /// File priority.
    public let priority: Priority
    
    /// Percentage of file pieces currently available (percentage/100).
    public let availability: Float
    
    /// The first number is the starting piece index and the second number is the ending piece index (inclusive).
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
