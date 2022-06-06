import Foundation

extension Endpoint {
    static func filePriority(hash: String, files: Set<Int>, priority: TorrentContent.Priority) -> Endpoint {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "hash", value: hash))
        let ids = files.map { "\($0)"}.joined(separator: "|")
        queryItems.append(URLQueryItem(name: "id", value: ids))
        queryItems.append(URLQueryItem(name: "priority", value: "\(priority.rawValue)"))
        
        return Endpoint(
            path: "torrents/filePrio",
            queryItems: queryItems
        )
    }
}
