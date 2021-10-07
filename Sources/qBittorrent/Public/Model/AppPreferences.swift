//
//  AppPreferences.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 07..
//

import Foundation

public struct AppPreferences: Codable {
    enum CodingKeys: String, CodingKey {
        case isAutoTorrentManagementEnabled = "auto_tmm_enabled"
        case isStartPausedEnabled = "start_paused_enabled"
        case defaultSavePath = "save_path"
        
    }
    
    public let isAutoTorrentManagementEnabled: Bool
    public let isStartPausedEnabled: Bool
    public let defaultSavePath: String
}
