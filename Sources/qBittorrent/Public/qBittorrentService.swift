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
}
