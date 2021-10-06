//
//  qBittorrentService.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 03..
//

import Foundation
import Combine

public protocol qBittorrentService {
    func torrents() -> AnyPublisher<[TorrentInfo], Error>
    
    func addTorrent(torrentFile: URL, configuration: AddTorrentConfiguration?) -> AnyPublisher<String, Error>
}

public struct AddTorrentConfiguration {
    public enum Management {
        case auto(category: String)
        case manual(savePath: String)
    }
    
    public let management: Management = .manual(savePath: "")
    public let paused: Bool = false
    public let sequentialDownload: Bool = false
    public let firstLastPiecePrio: Bool = false
}
