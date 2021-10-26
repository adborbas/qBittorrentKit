//
//  TorrentState.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 26..
//

import Foundation

/// Torrent state.
public enum TorrentState: String, Codable {
    
    /// Some error occurred, applies to paused torrents.
    case error
    
    /// Torrent data files is missing.
    case missingFiles
    
    ///Torrent is being seeded and data is being transferred.
    case uploading
    
    /// Torrent is paused and has finished downloading.
    case pausedUP
    
    /// Queuing is enabled and torrent is queued for upload.
    case queuedUP
    
    /// Torrent is being seeded, but no connection were made.
    case stalledUP
    
    /// Torrent has finished downloading and is being checked.
    case checkingUP
    
    /// Torrent is forced to uploading and ignore queue limit.
    case forcedUP
    
    /// Torrent is allocating disk space for download.
    case allocating
    
    /// Torrent is being downloaded and data is being transferred.
    case downloading
    
    /// Torrent has just started downloading and is fetching metadata.
    case metaDL
    
    /// Torrent is paused and has NOT finished downloading.
    case pausedDL
    
    /// Queuing is enabled and torrent is queued for download.
    case queuedDL
    
    /// Torrent is being downloaded, but no connection were made.
    case stalledDL
    
    /// Same as checkingUP, but torrent has NOT finished downloading.
    case checkingDL
    
    /// Torrent is forced to downloading to ignore queue limit.
    case forcedDL
    
    /// Checking resume data on qBt startup.
    case checkingResumeData
    
    /// Torrent is moving to another location.
    case moving
    
    /// Unknown status.
    case unknown
}
