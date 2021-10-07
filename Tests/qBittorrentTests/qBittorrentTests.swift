import XCTest
import Combine
@testable import qBittorrent

final class qBittorrentWebAPITests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    
    func testTorrents() throws {
        let service = givenService()
        let expectation = XCTestExpectation(description: "dsaadsda")
        service.torrents().sink { completion in
            print(completion)
            expectation.fulfill()
        } receiveValue: { infos in
            print(infos)
        }
        .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testAddTorrent() throws {
        let service = givenService()
        let expectation = XCTestExpectation(description: "dsaadsda")
        service.addTorrent(torrentFile: URL(fileURLWithPath: "/Users/adamborbas/Downloads/[nCore][hdser]Scenes.from.a.Marriage.S01E03.1080p.WEB.H264-GGWP.torrent"),
                           configuration: nil).sink { completion in
            print(completion)
            expectation.fulfill()
        } receiveValue: { result in
            print(result)
        }
        .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testCategories() throws {
        let service = givenService()
        let expectation = XCTestExpectation(description: "dsaadsda")
        service.categories().sink { completion in
            print(completion)
            expectation.fulfill()
        } receiveValue: { categories in
            print(categories)
        }
        .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func givenService() -> qBittorrentWebAPI {
        return qBittorrentWebAPI(username: "admin", password: "adminadmin")
    }
}
