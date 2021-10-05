//
//  BasicAuthCredentials.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation
import Alamofire

struct BasicAuthCredentials: Equatable, AuthenticationCredential {
    var requiresRefresh: Bool {
        return false
    }
    
    let username: String
    let password: String
}
