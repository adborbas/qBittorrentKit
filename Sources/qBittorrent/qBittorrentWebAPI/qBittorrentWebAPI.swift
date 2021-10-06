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
    
    public func addTorrent(file: URL, category: String) -> AnyPublisher<String, Error> {
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
                              fileManager: FileManager.default)
            .publishResponse(using: ForbiddenDecodableResponseSerializer())
            .value()
            .mapError { return $0 }
            .eraseToAnyPublisher()
    }
}

fileprivate class ForbiddenDecodableResponseSerializer<T: Decodable>: ResponseSerializer {
    typealias SerializedObject = T
    private let wrappedSerializer: DecodableResponseSerializer<T>
    
    init(of type: T.Type = T.self,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
         decoder: DataDecoder = JSONDecoder(),
         emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
         emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods) {
        self.wrappedSerializer = DecodableResponseSerializer(dataPreprocessor: dataPreprocessor,
                                                             decoder: decoder,
                                                             emptyResponseCodes: emptyResponseCodes,
                                                             emptyRequestMethods: emptyRequestMethods)
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        if let data = data,
           let stringData = String(data: data, encoding: .utf8),
           stringData == "Forbidden"{
            throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
        }
        
        return try wrappedSerializer.serialize(request: request, response: response, data: data, error: error)
    }
}

//fileprivate class AllowingFileManager: FileManager {
//    override func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
//        return self.fileExists(atPath: path) && !URL(fileURLWithPath: path).isFileURL
//    }
//}
