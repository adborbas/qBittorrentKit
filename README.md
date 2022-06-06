# qBittorrentKit

qBittorrentKit is a light-weight [qBittorrent](https://www.qbittorrent.org) client for iOS/macOS.

## Getting started

1. Initialize the client

```swift
let qBittorrent = qBittorrentWebAPI(scheme: .http,
            host: "myservice.local",
            authentication: .bypassed)
```

2. Call any of the supported features

```swift
qBittorrent.sink { completion in
    print("torrents received")
} receiveValue: { torrents in
    print(torrents)
}
```

## Features

[WebAPI methods of qBittorrent](https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-v3.2.0-v4.0.4))

### Torrent properties

- List torrents
- Get torrent generic parameters
- Set file priority
- Get torrent content

### Manage torrents

- Add torrent
- Delete torrent

### qBittorent config

- List categories
- Get app preferences
- Get webAPIVersion

## Install via SPM

1. Using Xcode go to File > Add Packages...
1. Paste the project URL: `https://github.com/adborbas/qBittorrentKit`
1. Click on next and select the project target

## Running tests

### Unit tests

1. Just run the test target.

### Integration tests

1. Have [qBittorrent](https://www.qbittorrent.org/download.php) installed somewhere.
1. Add your qBittorent credentials to `Tests/qBittorentTests/SECRET_SERVICE.swift`. Exmaple:

```swift
import Foundation
import qBittorrent

extension qBittorrentWebAPITests {
    func givenService() -> qBittorrentWebAPI {
        return qBittorrentWebAPI(scheme: .http,
                                 host: "<YOUR-qBittorent-ADDRESS>",
                                 authentication: .basicAuth(BasicAuthCredentials(username: "<USERNAME>", password: "<PASSWORD>")))
    }
}
```

3. Start tests in `qBittorrentWebAPITests`.
4. ⚠️ Note that that some tests require a torrent added to qBittorrent. To make these tests reproducible a `test.torrent` torrent will be added and then removed from the client.
