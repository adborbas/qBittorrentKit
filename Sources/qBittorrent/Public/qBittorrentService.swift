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
    func torrents(hash: String?) -> AnyPublisher<[TorrentInfo], qBittorrentWebAPIError>
    
    func addTorrent(torrentFile: URL, configuration: AddTorrentConfiguration?) -> AnyPublisher<String, qBittorrentWebAPIError>
    
    func deleteTorrent(hash: String, deleteFiles: Bool) -> AnyPublisher<String, qBittorrentWebAPIError>
    
    func categories() -> AnyPublisher<[TorrentCategory], qBittorrentWebAPIError>
     
    func appPreferences() -> AnyPublisher<AppPreferences, qBittorrentWebAPIError>
    
    func torrentGenericProperties(hash: String) -> AnyPublisher<TorrentGenericProperties, qBittorrentWebAPIError>
    
    func torrentContent(hash: String) -> AnyPublisher<[TorrentContent], qBittorrentWebAPIError>
    
    func setFilePriority(hash: String, files: Set<Int>, priority: TorrentContent.Priority) ->  AnyPublisher<String, qBittorrentWebAPIError>
    
    func webAPIVersion() -> AnyPublisher<Semver, qBittorrentWebAPIError>
}
