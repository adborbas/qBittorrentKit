import Foundation

extension Endpoint {
    static func webAPIVersion() -> Endpoint {
        return Endpoint(
            path: "app/webapiVersion",
            queryItems: []
        )
    }
}
