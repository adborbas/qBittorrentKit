//
//  BasicAuthCredentials.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation
import Alamofire

struct BasicAuthCredentials: Equatable {
    let username: String
    let password: String
}
