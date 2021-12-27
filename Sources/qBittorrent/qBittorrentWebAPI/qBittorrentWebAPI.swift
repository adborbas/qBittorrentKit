//
//  qBittorrentWebAPI.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation
import Combine
import Alamofire

public enum qBittorrentWebAPIError: Error {
    case invalidURL
}

// TODO: handle error codes
public class qBittorrentWebAPI: qBittorrentService {
    public static let defaultPort = 24560
    
    private enum Constants {
        static let apiBase = "/api/v2"
    }
    
    public enum Authentication {
        case bypassed
        case basicAuth(BasicAuthCredentials)
    }
    
    public enum Scheme: String {
        case http = "http"
        case https = "https"
    }
    
    private let session: Session
    private let endpointBuilder: EndpointBuilder
    
    let host = ""
    let port = ""
    
    public init?(
        scheme: Scheme,
        host: String,
        port: Int = qBittorrentWebAPI.defaultPort,
        authentication: Authentication) {
            
            self.endpointBuilder = EndpointBuilder(scheme: scheme.rawValue,
                                                   host: host,
                                                   port: port,
                                                   basePath: Constants.apiBase)
            
            switch authentication {
            case .bypassed:
                self.session = Session()
            case .basicAuth(let basicAuthCredentials):
                self.session = Session(interceptor: BasicAuthAuthenticatorRetrier(credentials: basicAuthCredentials))
            }
        }
    
    public func torrents(hash: String?) -> AnyPublisher<[TorrentInfo], Error> {
        return request(endpoint: Endpoint.torrents(hash: hash))
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
    
    public func torrentGenericProperties(hash: String) -> AnyPublisher<TorrentGenericProperties, Error> {
        return session.request("http://\(host):\(port)/api/v2/torrents/properties?hash=\(hash)", method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    public func torrentContent(hash: String) -> AnyPublisher<[TorrentContent], Error> {
        let hashString = "?hash=\(hash)"
        return session.request("http://\(host):\(port)/api/v2/torrents/files\(hashString)", method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { return $0 }
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
    
    private func request<Output>(endpoint: Endpoint) -> AnyPublisher<Output, Error>  where Output: Decodable {
        guard let url = endpointBuilder.url(for: endpoint) else {
            return Fail<Output, Error>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
}
