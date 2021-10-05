import XCTest
import Combine
@testable import qBittorrent

final class qBittorrentWebAPITests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    
    func testExample() throws {
        let service = qBittorrentWebAPI(username: "admin", password: "adminadmin")
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
}
