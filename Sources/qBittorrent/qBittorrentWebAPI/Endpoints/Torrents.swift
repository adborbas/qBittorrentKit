//
//  Torrents.swift
//  
//
//  Created by Adam Borbas on 2021. 11. 20..
//

import Foundation
import Alamofire

extension Endpoint {
    static func torrents(hash: String?) -> Endpoint {
        
        var queryItems = [URLQueryItem]()
        if let hash = hash {
            queryItems.append(URLQueryItem(name: "hashes", value: hash))
        }
        
        return Endpoint(
            path: "torrents/info",
            queryItems: queryItems
        )
    }
}
