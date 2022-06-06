import Foundation

extension Endpoint {
    static func preferences() -> Endpoint {
        return Endpoint(
            path: "app/preferences",
            queryItems: []
        )
    }
}
