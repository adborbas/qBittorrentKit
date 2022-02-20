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
    case forbidden
    case wrapped(original: Error)
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
    
    public func torrents(hash: String?) -> AnyPublisher<[TorrentInfo], qBittorrentWebAPIError> {
        return request(endpoint: Endpoint.torrents(hash: hash))
    }
    
    public func addTorrent(torrentFile: URL, configuration: AddTorrentConfiguration?) -> AnyPublisher<String, qBittorrentWebAPIError> {
        guard let url = endpointBuilder.url(for: Endpoint.add()) else {
            return Fail<String, qBittorrentWebAPIError>(error: qBittorrentWebAPIError.invalidURL)
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
            .mapError { self.mapWebAPIError($0) }
            .eraseToAnyPublisher()
    }
    
    public func deleteTorrent(hash: String, deleteFiles: Bool) -> AnyPublisher<String, qBittorrentWebAPIError> {
        guard let url = endpointBuilder.url(for: Endpoint.delete(hash: hash, deleteFiles: deleteFiles)) else {
            return Fail<String, qBittorrentWebAPIError>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenEmptyResponseSerializer())
            .value()
            .mapError { self.mapWebAPIError($0) }
            .eraseToAnyPublisher()
    }
    
    public func categories() -> AnyPublisher<[TorrentCategory], qBittorrentWebAPIError> {
        guard let url = endpointBuilder.url(for: Endpoint.categories()) else {
            return Fail<[TorrentCategory], qBittorrentWebAPIError>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer(of: TorrentCategoryResponse.self))
            .value()
            .map { $0.categories }
            .mapError { self.mapWebAPIError($0) }
            .eraseToAnyPublisher()
    }
    
    public func appPreferences() -> AnyPublisher<AppPreferences, qBittorrentWebAPIError> {
        return request(endpoint: Endpoint.preferences())
    }
    
    public func torrentGenericProperties(hash: String) -> AnyPublisher<TorrentGenericProperties, qBittorrentWebAPIError> {
        return request(endpoint: Endpoint.properties(hash: hash))
    }
    
    public func torrentContent(hash: String) -> AnyPublisher<[TorrentContent], qBittorrentWebAPIError> {
        return request(endpoint: Endpoint.files(hash: hash))
    }
    
    public func setFilePriority(hash: String, files: Set<Int>, priority: TorrentContent.Priority) ->  AnyPublisher<String, qBittorrentWebAPIError> {
        guard let url = endpointBuilder.url(for: Endpoint.filePriority(hash: hash, files: files, priority: priority)) else {
            return Fail<String, qBittorrentWebAPIError>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenEmptyResponseSerializer())
            .value()
            .mapError { self.mapWebAPIError($0) }
            .eraseToAnyPublisher()
    }
    
    public func webAPIVersion() -> AnyPublisher<Semver, qBittorrentWebAPIError> {
        guard let url = endpointBuilder.url(for: Endpoint.webAPIVersion()) else {
            return Fail<Semver, qBittorrentWebAPIError>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenEmptyResponseSerializer())
            .value()
            .compactMap { Semver($0) }
            .mapError { self.mapWebAPIError($0) }
            .eraseToAnyPublisher()
    }
    
    private func request<Output>(endpoint: Endpoint) -> AnyPublisher<Output, qBittorrentWebAPIError>  where Output: Decodable {
        guard let url = endpointBuilder.url(for: endpoint) else {
            return Fail<Output, qBittorrentWebAPIError>(error: qBittorrentWebAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url, method: .get)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { self.mapWebAPIError($0) }
            .eraseToAnyPublisher()
    }
    
    private func mapWebAPIError(_ error: Error) -> qBittorrentWebAPIError {
        if case AFError.requestRetryFailed(retryError: let retryError, originalError: _) = error,
            .forbidden == retryError as? AuthError {
            return qBittorrentWebAPIError.forbidden
        }
        return qBittorrentWebAPIError.wrapped(original: error)
    }
}
