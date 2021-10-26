//
//  qBittorrentService.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 03..
//

import Foundation
import Combine

// TODO check version of service to be > 2.8.2 cause of content.index
public protocol qBittorrentService {
    func torrents(hash: String?) -> AnyPublisher<[TorrentInfo], Error>
    
    func addTorrent(torrentFile: URL, configuration: AddTorrentConfiguration?) -> AnyPublisher<String, Error>
    
    func categories() -> AnyPublisher<[TorrentCategory], Error>
     
    func appPreferences() -> AnyPublisher<AppPreferences, Error>
    
    func TorrentGenericProperties(hash: String) -> AnyPublisher<TorrentGenericProperties, Error>
    
    func torrentContent(hash: String) -> AnyPublisher<[TorrentContent], Error>
}
