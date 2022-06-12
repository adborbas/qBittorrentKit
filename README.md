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
qBittorrent.torrents(hash: nil).sink { completion in
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

1. Start test by:

   ```bash
   swift test --filter UnitTests
   ```

### Integration tests

1. [Install Docker](https://docs.docker.com/get-docker/)
2. Start qBittorrent server in Docker by:

   ```bash
   docker-compose -f ./Resources/docker-compose.yml up -d
   ```

3. Run the tests

   ```bash
   swift test --filter IntegrationTests
   ```
