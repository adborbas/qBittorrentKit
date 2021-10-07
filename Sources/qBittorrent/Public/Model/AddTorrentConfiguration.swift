//
//  AddTorrentConfiguration.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 07..
//

import Foundation

public struct AddTorrentConfiguration {
    public enum Management {
        case auto(category: String)
        case manual(savePath: String)
    }
    
    public let management: Management
    public let paused: Bool
    public let sequentialDownload: Bool
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
