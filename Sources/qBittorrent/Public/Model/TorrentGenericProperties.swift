//
//  TorrentGenericProperties.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 09..
//

import Foundation

/// Torrent generic properties.
public struct TorrentGenericProperties: Decodable {
    enum CodingKeys: String, CodingKey {
        case savePath = "save_path"
        case totalSize = "total_size"
        case totalDownloaded = "total_downloaded"
        case totalUploaded = "total_uploaded"
        case downloadSpeed = "dl_speed"
        case downloadSpeedLimit = "dl_limit"
        case downloadSpeedAvg = "dl_speed_avg"
        case uploadSpeed = "up_speed"
        case uploadSpeedLimit = "up_limit"
        case uploadSpeedAvg = "up_speed_avg"
        case eta = "eta"
        case seeds = "seeds"
        case seedsTotal = "seeds_total"
        case peers = "peers"
        case peersTotal = "peers_total"
        case comment = "comment"
        case totalUploaded = "total_uploaded"
        case timeElapsed = "time_elapsed"
        case shareRatio = "share_ratio"
        case additionDate = "addition_date"
        case comment = "comment"
        case seedingTime = "seeding_time"
    }
    
    
    /// Torrent save path.
    public let savePath: String
    
    /// Torrent total size (bytes).
    public let totalSize: Int64
    
    /// Total data downloaded for torrent (bytes).
    public let totalDownloaded: Int64
    
    /// Total data uploaded for torrent (bytes).
    public let totoalUploaded: Int64
    
    /// Torrent download speed (bytes/second).
    public let downloadSpeed: Int64
    
    /// Torrent download limit (bytes/s).
    public let downloadSpeedLimit: Int64
    
    /// Torrent average download speed (bytes/second).
    public let downloadSpeedAvg: Int64
    
    /// Torrent upload speed (bytes/second).
    public let uploadSpeed: Int64
    
    /// Torrent upload limit (bytes/s).
    public let uploadSpeedLimit: Int64
    
    /// Torrent average upload speed (bytes/second).
    public let uploadSpeedAvg: Int64
    
    /// Torrent ETA (seconds).
    public let eta: Int
    
    /// Number of seeds connected to.
    public let seeds: Int
    
    /// Number of seeds in the swarm.
    public let seedsTotal: Int
    
    /// Number of peers connected to.
    public let peers: Int
    
    /// Number of peers in the swarm.
    public let peersTotal: Int
    
    /// Torrent comment.
    public let comment: String
    
    /// Total data uploaded for torrent (bytes).
    public let totalUploaded: Int64
    
    /// Torrent elapsed time (seconds).
    public let timeElapsed: Int
    
    /// Torrent share ratio.
    public let shareRatio: Float
    
    /// When this torrent was added (unix timestamp).
    public let additionDate: Int64
    
    /// Torrent comment.
    public let comment: String
    
    /// Torrent elapsed time while complete (seconds).
    public let seedingTime: Int
}
