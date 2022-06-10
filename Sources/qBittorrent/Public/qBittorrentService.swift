import Foundation
import Combine

public protocol qBittorrentService {
    
    
    /**
     List of torrents managed by the client.
     
     - Parameters:
        - hash: The hash of the torrent filtered for.
     */
    func torrents(hash: String?) -> AnyPublisher<[TorrentInfo], qBittorrentWebAPIError>
    
    /**
     Adds a torrent to manage by the client.
     
     - Parameters:
         - torrentFile: URL of the torrent file to add.
         - configuration: Configuration for the new torrent.
     */
    func addTorrent(torrentFile: URL, configuration: AddTorrentConfiguration?) -> AnyPublisher<String, qBittorrentWebAPIError>
    
    /**
     Deletes a torrent.
     
     - Parameters:
         - hash: The hash of the torrent.
         - deleteFiles: `true` if the torrent's content should be deleted from the disk; `false` otherwise.
     */
    func deleteTorrent(hash: String, deleteFiles: Bool) -> AnyPublisher<String, qBittorrentWebAPIError>
    
    /**
     List of categories of the client.
     */
    func categories() -> AnyPublisher<[TorrentCategory], qBittorrentWebAPIError>
    
    /**
     Preferences of the client.
     */
    func appPreferences() -> AnyPublisher<AppPreferences, qBittorrentWebAPIError>
    
    /**
     Generic properties of a torrent.
     
     - Parameters:
        - hash: The hash of the torrent.
     */
    func torrentGenericProperties(hash: String) -> AnyPublisher<TorrentGenericProperties, qBittorrentWebAPIError>
    
    /**
     Content properties of a torrent.
     
     - Parameters:
        - hash: The hash of the torrent.
     */
    func torrentContent(hash: String) -> AnyPublisher<[TorrentContent], qBittorrentWebAPIError>
    
    /**
     Set the priority for file(s).
     
     - Parameters:
         - hash: The hash of the torrent.
         - files: Indexes of the files that the priority should be set.
         - priority: The new priority to apply.
     */
    func setFilePriority(hash: String, files: Set<Int>, priority: TorrentContent.Priority) ->  AnyPublisher<String, qBittorrentWebAPIError>
    
    /**
     Returns the Web API version.
     */
    func webAPIVersion() -> AnyPublisher<Semver, qBittorrentWebAPIError>
}
