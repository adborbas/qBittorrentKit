import XCTest
import Combine
@testable import qBittorrent

final class qBittorrentWebAPITests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    private let hashString = "b0b654b4c7815a0fb0783df4a593e45133556bfb"
    
    func testTorrents() throws {
        let service = givenService()
        let torrents = try awaitPublisher(service.torrents(hash: nil))
        XCTAssertNotNil(torrents)
    }
    
    func testAddTorrent() throws {
        return
        let service = givenService()
        let torrent = URL(fileURLWithPath: "/Users/adamborbas/Downloads/[nCore][hdser]Scenes.from.a.Marriage.S01E03.1080p.WEB.H264-GGWP.torrent")
        let added = try awaitPublisher(service.addTorrent(torrentFile: torrent,
                                                          configuration: nil))
        XCTAssertNotNil(added)
    }
    
    func testCategories() throws {
        let service = givenService()
        let categories = try awaitPublisher(service.categories())
        XCTAssertNotNil(categories)
    }
    
    func testAppPreferences() throws {
        let service = givenService()
        let preferences = try awaitPublisher(service.appPreferences())
        XCTAssertNotNil(preferences)
    }
    
    func testTorrentGenericProperties() throws {
        let service = givenService()
        let properties = try awaitPublisher(service.torrentGenericProperties(hash: hashString))
        XCTAssertNotNil(properties)
    }
    
    func testTorrentContent() throws {
        let service = givenService()
        let content = try awaitPublisher(service.torrentContent(hash: hashString))
        XCTAssertNotNil(content)
    }
    
    private func givenService() -> qBittorrentWebAPI {
        return qBittorrentWebAPI(username: "admin", password: "adminadmin")
    }
}
