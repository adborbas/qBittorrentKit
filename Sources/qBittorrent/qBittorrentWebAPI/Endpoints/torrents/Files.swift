//
//  Files.swift
//  
//
//  Created by Adam Borbas on 2021. 12. 27..
//

import Foundation

extension Endpoint {
    static func files(hash: String) -> Endpoint {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "hash", value: hash))
        
        return Endpoint(
            path: "torrents/files",
            queryItems: queryItems
        )
    }
}
