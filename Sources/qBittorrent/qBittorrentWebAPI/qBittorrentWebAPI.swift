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
    
    public init(
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
        guard let url = endpointBuilder.url(for: Endpoint.add()) else {
            return Fail<String, Error>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.upload(multipartFormData: { Endpoint.addMultipartFormData(file: torrentFile,
                                                                                 configuration: configuration,
                                                                                 to: $0) },
                              to: url,
                              method: .post,
                              fileManager: FileManager.default)
            .publishResponse(using: ForbiddenStringResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
    
    public func deleteTorrent(hash: String, deleteFiles: Bool) -> AnyPublisher<String, Error> {
        guard let url = endpointBuilder.url(for: Endpoint.delete(hash: hash, deleteFiles: deleteFiles)) else {
            return Fail<String, Error>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenEmptyResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
    
    public func categories() -> AnyPublisher<[TorrentCategory], Error> {
        guard let url = endpointBuilder.url(for: Endpoint.categories()) else {
            return Fail<[TorrentCategory], Error>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer(of: TorrentCategoryResponse.self))
            .value()
            .map { $0.categories }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    public func appPreferences() -> AnyPublisher<AppPreferences, Error> {
        return request(endpoint: Endpoint.preferences())
    }
    
    public func torrentGenericProperties(hash: String) -> AnyPublisher<TorrentGenericProperties, Error> {
        return request(endpoint: Endpoint.properties(hash: hash))
    }
    
    public func torrentContent(hash: String) -> AnyPublisher<[TorrentContent], Error> {
        return request(endpoint: Endpoint.files(hash: hash))
    }
    
    public func setFilePriority(hash: String, files: Set<Int>, priority: TorrentContent.Priority) ->  AnyPublisher<String, Error> {
        guard let url = endpointBuilder.url(for: Endpoint.filePriority(hash: hash, files: files, priority: priority)) else {
            return Fail<String, Error>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenEmptyResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
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
