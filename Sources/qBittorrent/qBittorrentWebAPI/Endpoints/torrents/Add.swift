//
//  File.swift
//  
//
//  Created by Adam Borbas on 2021. 12. 27..
//

import Foundation
import Alamofire

extension Endpoint {
    static func add() -> Endpoint {
        return Endpoint(
            path: "torrents/add",
            queryItems: []
        )
    }
    
    static func addMultipartFormData(file: URL,
                          configuration: AddTorrentConfiguration?,
                          to multipartFormData: MultipartFormData) {
        
        multipartFormData.append(file,
                                 withName: "torrents",
                                 fileName: file.lastPathComponent,
                                 mimeType: "application/x-bittorrent")
        
        let configuration = configuration ?? AddTorrentConfiguration()
        
        switch configuration.management {
        case .auto(let category):
            multipartFormData.append(true, withName: "autoTMM")
            multipartFormData.append(category.data(using: .utf8)!, withName: "category")
        case .manual(let savePath):
            multipartFormData.append(false, withName: "autoTMM")
            multipartFormData.append(savePath.data(using: .utf8)!, withName: "savepath")
        }
        
        if configuration.paused {
            multipartFormData.append(true, withName: "paused")
        }
        if configuration.firstLastPiecePrio {
            multipartFormData.append(true, withName: "sequentialDownload")
        }
        if configuration.sequentialDownload {
            multipartFormData.append(true, withName: "firstLastPiecePrio")
        }
    }
}

extension MultipartFormData {
    func append(_ value: Bool, withName name: String) {
        self.append(value.asMultipartFormData(), withName: name)
    }
}

extension Bool {
    func asMultipartFormData() -> Data {
        if self {
            return "true".data(using: .utf8)!
        }
        
        return "false".data(using: .utf8)!
    }
}
