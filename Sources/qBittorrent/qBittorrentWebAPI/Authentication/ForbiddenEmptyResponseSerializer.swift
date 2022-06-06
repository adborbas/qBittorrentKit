import Foundation
import Alamofire

class ForbiddenEmptyResponseSerializer: ForbiddenDecodableResponseSerializer<String> {
    override func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> String {
        guard let data = data,
              let stringResponse = String(data: data, encoding: .utf8) else {
                  return "OK"
              }
        
        if stringResponse == "Forbidden" {
            throw AuthenticationError.excessiveRefresh
        }
        
        return stringResponse
    }
}
