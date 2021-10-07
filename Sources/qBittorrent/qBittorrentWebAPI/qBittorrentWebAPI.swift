//
//  qBittorrentWebAPI.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation
import Combine
import Alamofire

public class qBittorrentWebAPI: qBittorrentService {
    private let session: Session
    private let host: String = "192.168.50.108"
    private let port: Int = 24560
    
    public init(username: String, password: String) {
        let basicAuthCredentials = BasicAuthCredentials(username: username, password: password)
        self.session = Session(interceptor: BasicAuthAuthenticatorRetrier(credentials: basicAuthCredentials))
    }
    
    public func torrents() -> AnyPublisher<[TorrentInfo], Error> {
        return session.request("http://\(host):\(port)/api/v2/torrents/info", method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
    
    public func addTorrent(torrentFile: URL, configuration: AddTorrentConfiguration?) -> AnyPublisher<String, Error> {
        return session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(torrentFile,
                                     withName: "torrents",
                                     fileName: torrentFile.lastPathComponent,
                                     mimeType: "application/x-bittorrent")
            
            let configuration = configuration ?? AddTorrentConfiguration()
            self.append(configuration, to: multipartFormData)
        },
                              to: "http://\(host):\(port)/api/v2/torrents/add",
                              method: .post,
                              fileManager: FileManager.default)
            .publishResponse(using: ForbiddenStringResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
    
    public func categories() -> AnyPublisher<[TorrentCategory], Error> {
        return session.request("http://\(host):\(port)/api/v2/torrents/categories", method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer(of: TorrentCategoryResponse.self))
            .value()
            .map { $0.categories }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    public func appPreferences() -> AnyPublisher<AppPreferences, Error> {
        return session.request("http://\(host):\(port)/api/v2/app/preferences", method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    private func append(_ configuration: AddTorrentConfiguration, to multipartFormData: MultipartFormData) {
        switch configuration.management {
        case .auto(let category):
            multipartFormData.append("true".data(using: .utf8)!, withName: "autoTMM")
            multipartFormData.append(category.data(using: .utf8)!, withName: "category")
        case .manual(let savePath):
            multipartFormData.append("false".data(using: .utf8)!, withName: "autoTMM")
            multipartFormData.append(savePath.data(using: .utf8)!, withName: "savepath")
        }
        
        if configuration.paused {
            multipartFormData.append("true".data(using: .utf8)!, withName: "paused")
        }
        if configuration.firstLastPiecePrio {
            multipartFormData.append("true".data(using: .utf8)!, withName: "sequentialDownload")
        }
        if configuration.sequentialDownload {
            multipartFormData.append("true".data(using: .utf8)!, withName: "firstLastPiecePrio")
        }
    }
}
