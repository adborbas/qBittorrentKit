//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation

public struct TorrentInfo: Codable, Equatable {
    public let name: String
    public let state: String
}
