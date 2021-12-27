//
//  Categories.swift
//  
//
//  Created by Adam Borbas on 2021. 11. 20..
//

import Foundation

extension Endpoint {
    static func categories() -> Endpoint {
        return Endpoint(
            path: "torrents/categories",
            queryItems: []
        )
    }
}

