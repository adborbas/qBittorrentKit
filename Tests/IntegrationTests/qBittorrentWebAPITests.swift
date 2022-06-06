import XCTest
import Combine
@testable import qBittorrent

final class qBittorrentWebAPITests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var testTorrent = URL(fileURLWithPath: Bundle.module.path(forResource: "test", ofType: "torrent")!)
    
    func test_WhenTorrentsListed_ThenExpectNotEmpty() throws {
        // Given
        let service = givenService()
        
        // When
        let torrents = try awaitPublisher(service.torrents(hash: nil))
        
        // Then
        XCTAssertNotNil(torrents)
    }
    
    func test_GivenTorrentDoesNotExists_WhenAddTorrentCalled_ThenTorrentAdded() throws {
        // Given
        let service = givenService()
        try givenTestTorrentDoesNotExists(on: service)
        
        // When
        let added = try addTorrent(testTorrent, to: service)
        
        // Then
        XCTAssertNotNil(added)
        let testTorrent = try assertTestTorrentExists(on: service)
        try deleteTorrent(testTorrent, on: service)
    }
    
    func test_GivenTorrentExists_WhenDeleteCalled_ThenTorrentShouldBeDeleted() throws {
        // Given
        let service = givenService()
        let torrent = try givenTestTorrentExists(on: service)
        
        // When
        _ = try awaitPublisher(service.deleteTorrent(hash: torrent.hash, deleteFiles: true))
        
        // Then
        try assertTestTorrentDoesNotExist(on: service)
    }
    
    func test_WhenCategoriesListed_ThenExpectNotEmpty() throws {
        // Given
        let service = givenService()
        
        // When
        let categories = try awaitPublisher(service.categories())
        
        // Then
        XCTAssertNotNil(categories)
    }
    
    func test_WhenAppPreferencesCalled_ThenExpectNotNil() throws {
        // Given
        let service = givenService()
        
        // When
        let preferences = try awaitPublisher(service.appPreferences())
        
        // Then
        XCTAssertNotNil(preferences)
    }
    
    func test_GivenTorrentExists_WhenTorrentGenericPropertiesCalled_ThenExpectNotNil() throws {
        // Given
        let service = givenService()
        let torrent = try givenTestTorrentExists(on: service)
        defer {
            try? deleteTorrent(torrent, on: service)
        }
        
        // When
        let properties = try awaitPublisher(service.torrentGenericProperties(hash: torrent.hash))
        
        // Then
        XCTAssertNotNil(properties)
    }

    func test_GivenTorrentExists_WhenTorrentContentCalled_ThenExpectNotNil() throws {
        // Given
        let service = givenService()
        let torrent = try givenTestTorrentExists(on: service)
        defer {
            try? deleteTorrent(torrent, on: service)
        }
        
        // When
        let content = try awaitPublisher(service.torrentContent(hash: torrent.hash))
        
        // Then
        XCTAssertNotNil(content)
    }
    
    func test_GivenTorrentExists_WhenSetPriorityCalled_ThenExpectPrioSet() throws {
        // Given
        let service = givenService()
        let torrent = try givenTestTorrentExists(on: service)
        let expectedPriority: TorrentContent.Priority = .maximum
        defer {
            try? deleteTorrent(torrent, on: service)
        }
        
        // When
        let content = try awaitPublisher(service.torrentContent(hash: torrent.hash))
        _ = try awaitPublisher(service.setFilePriority(hash:torrent.hash, files: [content[0].index], priority: expectedPriority))
        
        // Then
        let updatedContent = try awaitPublisher(service.torrentContent(hash: torrent.hash))
        XCTAssertEqual(updatedContent[0].priority, expectedPriority)
    }
    
    func test_WhenVersionCalled_ThenExpectNotNil() throws {
        // Given
        let service = givenService()
        
        // When
        let version = try awaitPublisher(service.webAPIVersion())
        
        // Then
        XCTAssertNotNil(version)
    }
    
    // MARK: - Private functions
    private func addTorrent(_ torrent: URL, to service: qBittorrentWebAPI) throws -> String {
        return try awaitPublisher(service.addTorrent(torrentFile: torrent,
                                                          configuration: nil))
    }
    
    private func givenTestTorrentDoesNotExists(on service: qBittorrentWebAPI) throws {
        let torrents = try self.awaitPublisher(service.torrents(hash: nil))
        let testTorrent = torrents.first { $0.name == "test.txt"}
        XCTAssertNil(testTorrent, "test.torrent should not exist")
    }
    
    private func givenTestTorrentExists(on service: qBittorrentWebAPI) throws -> TorrentInfo {
        try givenTestTorrentDoesNotExists(on: service)
        _ = try addTorrent(testTorrent, to: service)
        return try assertTestTorrentExists(on: service)
    }
    
    private func assertTestTorrentExists(on service: qBittorrentWebAPI) throws -> TorrentInfo {
        let torrents = try self.awaitPublisher(service.torrents(hash: nil))
        let testTorrent = torrents.first { $0.name == "test.txt"}
        return try XCTUnwrap(testTorrent, "test.torrent should be added to service")
    }
    
    private func assertTestTorrentDoesNotExist(on service: qBittorrentWebAPI) throws {
        let torrents = try self.awaitPublisher(service.torrents(hash: nil))
        XCTAssertFalse(torrents.contains { $0.name == "test.txt"})
    }
    
    private func deleteTorrent(_ torrent: TorrentInfo, on service: qBittorrentWebAPI) throws {
        _ = try self.awaitPublisher(service.deleteTorrent(hash: torrent.hash, deleteFiles: true))
    }
}
