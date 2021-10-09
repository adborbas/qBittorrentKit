//
//  TorrentGeneralProperties.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 09..
//

import Foundation

public struct TorrentGeneralProperties: Decodable {
    enum CodingKeys: String, CodingKey {
        case savePath = "save_path"
        case totalSize = "total_size"
        case downloadedSize = "total_downloaded"
        case downloadSpeed = "dl_speed"
        case downloadSpeedAvg = "dl_speed_avg"
        case uploadSpeed = "up_speed"
        case uploadSpeedAvg = "up_speed_avg"
        case eta = "eta"
        case seeds = "seeds"
        case seedsTotal = "seeds_total"
        case peers = "peers"
        case peersTotal = "peers_total"
        case creationDate = "creation_date"
        case comment = "comment"
        case totalUploaded = "total_uploaded"
        case timeElapsed = "time_elapsed"
        case shareRatio = "share_ratio"
        case additionDate = "addition_date"
    }
    
    // name
    // status
    // category
    
    public let savePath: String
    public let creationDate: Int64
    public let totalSize: Int64
    public let downloadedSize: Int64
    public let downloadSpeed: Int64
    public let downloadSpeedAvg: Int64
    public let uploadSpeed: Int64
    public let uploadSpeedAvg: Int64
    public let eta: Int
    public let seeds: Int
    public let seedsTotal: Int
    public let peers: Int
    public let peersTotal: Int
    public let comment: String
    public let totalUploaded: Int64
    public let timeElapsed: Int
    public let shareRatio: Float
    public let additionDate: Int64
}
