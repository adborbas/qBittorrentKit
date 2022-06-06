import Foundation

extension Endpoint {
    static func delete(hash: String, deleteFiles: Bool) -> Endpoint {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "hashes", value: hash))
        queryItems.append(URLQueryItem(name: "deleteFiles", value: deleteFiles.string))
        
        return Endpoint(
            path: "torrents/delete",
            queryItems: queryItems
        )
    }
}

extension Bool {
    var string: String {
        self ? "true" : "false"
    }
}
