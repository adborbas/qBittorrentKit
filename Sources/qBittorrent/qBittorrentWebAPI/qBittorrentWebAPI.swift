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
            .publishDecodable()
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
    
    public func addTorrent(file: URL, category: String) -> AnyPublisher<Void, Error> {
        return session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(file,
                                     withName: "torrents",
                                     fileName: file.lastPathComponent,
                                     mimeType: "application/x-bittorrent")
            multipartFormData.append(category.data(using: .utf8)!, withName: "category")
            multipartFormData.append("true".data(using: .utf8)!, withName: "autoTMM")
            multipartFormData.append("true".data(using: .utf8)!, withName: "paused")
        },
                              to: "http://\(host):\(port)/api/v2/torrents/add",
                              method: .post,
                              fileManager: SmartAFFileManager())
            .publishDecodable(type: String.self)
            .value()
            .map { value -> String in
                print("addTorrent response: \(value)")
                return value
            }
            .map { whatever in return Void() }
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
}

class SmartAFFileManager: FileManager {
    override func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        return URL(fileURLWithPath: path).isFileURL
    }
}
