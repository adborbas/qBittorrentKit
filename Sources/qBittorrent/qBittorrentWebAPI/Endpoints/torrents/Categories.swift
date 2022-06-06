import Foundation

extension Endpoint {
    static func categories() -> Endpoint {
        return Endpoint(
            path: "torrents/categories",
            queryItems: []
        )
    }
}

