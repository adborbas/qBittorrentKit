//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation

/**
 Torrents info response.
 
 Response objects for the `/api/v2/torrents/info` endpoint.
*/
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
        case uploaded = "uploaded"
        case amountLeft = "amount_left"
        case eta = "eta"
        case ratio = "ratio"
        case size = "size"
        case totalSize = "total_size"
        case uploadSpeed = "upspeed"
        case downloadSpeed = "dlspeed"
    }
    
    /// Torrent name.
    public let name: String
    
    /// Torrent state.
    public let state: TorrentState
    
    /// Torrent hash.
    public let hash: String
    
    /// Category of the torrent.
    public let category: String
    
    /// Comma-concatenated tag list of the torrent.
    public let tags: [String]
    
    /// Torrent progress (percentage/100).
    public let progress: Float
    
    /// Time (Unix Epoch) when the torrent was added to the client.
    public let addedDate: Date
    
    /// Time (Unix Epoch) when the torrent completed.
    public let completionDate: Date
    
    /// Amount of data left to download in bytes.
    public let amountLeft: Int64
    
    /// Amount of data downloaded in bytes.
    public let downloaded: Int64
    
    /// Amount of data uploaded in bytes.
    public let uploaded: Int64
    
    /// Torrent ETA in seconds.
    public let eta: Int
    
    /// Torrent share ratio. Max ratio value: 9999.
    public let ratio: Float
    
    /// Total size of files selected for download in bytes.
    public let size: Int64
    
    /// Total size  of all file in this torrent (including unselected ones) in bytes.
    public let totalSize: Int64
    
    /// Torrent upload speed in bytes/s.
    public let uploadSpeed: Int64
    
    /// Torrent download speed in bytes/s.
    public let downloadSpeed: Int64
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.state = try container.decode(TorrentState.self, forKey: .state)
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
        self.uploaded = try container.decode(Int64.self, forKey: .uploaded)
        self.eta = try container.decode(Int.self, forKey: .eta)
        self.ratio = try container.decode(Float.self, forKey: .ratio)
        self.size = try container.decode(Int64.self, forKey: .size)
        self.totalSize = try container.decode(Int64.self, forKey: .totalSize)
        self.uploadSpeed = try container.decode(Int64.self, forKey: .uploadSpeed)
        self.downloadSpeed = try container.decode(Int64.self, forKey: .downloadSpeed)
    }
}
