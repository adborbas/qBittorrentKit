//
//  Endpoint.swift
//  
//
//  Created by Adam Borbas on 2021. 11. 20..
//

import Foundation

struct EndpointBuilder {
    let scheme: String
    let host: String
    let port: Int
    let basePath: String
    
    func url(for endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = basePath
        components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        
        return components.url?.appendingPathComponent(endpoint.path)
    }
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}
