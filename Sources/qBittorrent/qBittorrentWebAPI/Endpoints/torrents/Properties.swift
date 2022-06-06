import Foundation

extension Endpoint {
    static func properties(hash: String) -> Endpoint {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "hash", value: hash))
        
        return Endpoint(
            path: "torrents/properties",
            queryItems: queryItems
        )
    }
}
