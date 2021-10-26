//
//  AppPreferences.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 07..
//

import Foundation

/// Application preferences.
public struct AppPreferences: Codable {
    enum CodingKeys: String, CodingKey {
        case isAutoTorrentManagementEnabled = "auto_tmm_enabled"
        case isStartPausedEnabled = "start_paused_enabled"
        case defaultSavePath = "save_path"
        
    }
    
    /// `true` if Automatic Torrent Management is enabled by default.
    public let isAutoTorrentManagementEnabled: Bool
    
    /// `true` if torrents should be added in a Paused state
    public let isStartPausedEnabled: Bool
    
    /// Default save path for torrents, separated by slashes.
    public let defaultSavePath: String
}
