//
//  WebAPIVersion.swift
//  
//
//  Created by Adam Borbas on 2022. 02. 20..
//

import Foundation

extension Endpoint {
    static func webAPIVersion() -> Endpoint {
        return Endpoint(
            path: "app/webapiVersion",
            queryItems: []
        )
    }
}
