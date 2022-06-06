import Foundation
import qBittorrent

extension qBittorrentWebAPITests {
    func givenService() -> qBittorrentWebAPI {
        return qBittorrentWebAPI(scheme: .http,
                                 host: "localhost",
                                 authentication: .basicAuth(BasicAuthCredentials(username: "admin", password: "adminadmin")))
    }
}
