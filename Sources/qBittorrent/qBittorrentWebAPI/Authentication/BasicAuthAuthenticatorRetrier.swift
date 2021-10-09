//
//  BasicAuthAuthenticatorRetrier.swift
//  
//
//  Created by Adam Borbas on 2021. 10. 04..
//

import Foundation
import Alamofire

class BasicAuthAuthenticatorRetrier: RequestInterceptor {
    private let credentials: BasicAuthCredentials
    
    init(credentials: BasicAuthCredentials) {
        self.credentials = credentials
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 else {
            return completion(.doNotRetryWithError(error))
        }
        
        guard let url = request.request?.url,
              let baseURL = sidCookieURL(from: url) else {
            return completion(.doNotRetryWithError(error))
        }
        
        refreshAuthCookie(url: baseURL, for: session) { [weak self] error in
            guard self != nil else { return }
            
            if let error = error {
                completion(.doNotRetryWithError(error))
            }
            completion(.retry)
        }
    }
    
    func refreshAuthCookie(url: URL, for session: Session ,_ completionHandler: @escaping  (Error?) -> Void) {
        session.request(url)
            .response { response in
                completionHandler(response.error)
            }
    }
    
    private func sidCookieURL(from baseURL: URL) -> URL? {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.port = baseURL.port
        components.path = "/api/v2/auth/login"
        components.queryItems = [
            URLQueryItem(name: "username", value: credentials.username),
            URLQueryItem(name: "password", value: credentials.password)
        ]
        
        return components.url
    }
    
//    "http://192.168.50.108:24560/api/v2/auth/login?username=\(credentials.username)&password=\(credentials.password)"
}
