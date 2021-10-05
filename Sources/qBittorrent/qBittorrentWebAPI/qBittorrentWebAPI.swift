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
    private let username: String
    private let password: String
    private let session: Session
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
        
        self.session = Session(interceptor: BasicAuthAuthenticatorRetrier())
    }
    
    public func torrents() -> AnyPublisher<[TorrentInfo], Error> {
        session.request("http://raspberrypi.local:24560/api/v2/torrents/info", method: .get)
            .publishDecodable(type: [TorrentInfo].self)
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
//        return [TorrentInfo(name: "", status: "")]
//            .publisher
//            .collect()
//            .eraseToAnyPublisher()
    }
}
