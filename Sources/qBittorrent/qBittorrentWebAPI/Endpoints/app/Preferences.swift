//
//  Preferences.swift
//  
//
//  Created by Adam Borbas on 2021. 12. 27..
//

import Foundation

extension Endpoint {
    static func preferences() -> Endpoint {
        return Endpoint(
            path: "app/preferences",
            queryItems: []
        )
    }
}
