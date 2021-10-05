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
    
    public init(username: String, password: String) {
        let basicAuthCredentials = BasicAuthCredentials(username: username, password: password)
        self.session = Session(interceptor: BasicAuthAuthenticatorRetrier(credentials: basicAuthCredentials))
    }
    
    public func torrents() -> AnyPublisher<[TorrentInfo], Error> {
        session.request("http://192.168.50.108:24560/api/v2/torrents/info", method: .get)
            .publishDecodable(type: [TorrentInfo].self)
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
}
