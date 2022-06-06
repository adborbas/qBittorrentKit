import Foundation
import Alamofire

public struct BasicAuthCredentials: Equatable {
    let username: String
    let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
