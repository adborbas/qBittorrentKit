//
//  ForbiddenStringResponseSerializer.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 07..
//

import Foundation
import Alamofire

class ForbiddenStringResponseSerializer: ForbiddenDecodableResponseSerializer<String> {
    override func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> String {
        guard let data = data,
              let stringResponse = String(data: data, encoding: .utf8) else {
                  throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
              }
        
        if stringResponse == "Forbidden" {
            throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
        }
        
        return stringResponse
    }
}
