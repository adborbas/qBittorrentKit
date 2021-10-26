//
//  AddTorrentConfiguration.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 07..
//

import Foundation

/// Configuration for adding a new torrent.
public struct AddTorrentConfiguration {
    
    /// Torrent Management
    public enum Management {
        /// Automatic torrent management with category.
        case auto(category: String)
        
        /// Manual torrent management with save path.
        case manual(savePath: String)
    }
    
    /// Torrent Management.
    public let management: Management
    
    /// Add torrents in the paused state.
    public let paused: Bool
    
    /// Enable sequential download
    public let sequentialDownload: Bool
    
    /// Prioritize download first last piece
    public let firstLastPiecePrio: Bool
    
    public init(management: Management = .manual(savePath: ""),
                paused: Bool = false,
                sequentialDownload: Bool = false,
                firstLastPiecePrio: Bool = false) {
        self.management = management
        self.paused = paused
        self.sequentialDownload = sequentialDownload
        self.firstLastPiecePrio = firstLastPiecePrio
    }
}
