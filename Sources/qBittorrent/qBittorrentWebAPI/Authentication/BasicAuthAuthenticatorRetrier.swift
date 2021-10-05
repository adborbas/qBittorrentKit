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
        
        refreshAuthCookie(for: session) { [weak self] error in
            guard self != nil else { return }
            
            if let error = error {
                completion(.doNotRetryWithError(error))
            }
            completion(.retry)
        }
    }
    
    func refreshAuthCookie(for session: Session ,_ completionHandler: @escaping  (Error?) -> Void) {
        session.request("http://192.168.50.108:24560/api/v2/auth/login?username=\(credentials.username)&password=\(credentials.password)")
            .response { response in
                completionHandler(response.error)
            }
//        let sidCookie = HTTPCookie(properties: [
//            .domain: "raspberrypi.local",
//            .path: "/",
//            .name: "SID",
//            .value: "lFc6jT%2FAs%2B%2BNZF50ka%2FyGJPNSLHNh828"
//        ])!
//
//        session.sessionConfiguration.httpCookieStorage?.setCookie(sidCookie)
//
//        completionHandler(nil)
    }
    
    //    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    //        session.sessionConfiguration.httpCookieStorage?.cookies?.contains(where: { cookie in
    //            return cookie.
    //        })
    
    //        guard urlRequest.url?.absoluteString.hasPrefix("https://api.authenticated.com") == true else {
    //                   /// If the request does not require authentication, we can directly return it as unmodified.
    //                   return completion(.success(urlRequest))
    //               }
    //               var urlRequest = urlRequest
    //
    //               /// Set the Authorization header value using the access token.
    //               urlRequest.setValue("Bearer " + storage.accessToken, forHTTPHeaderField: "Authorization")
    //
    //               completion(.success(urlRequest))
    //    }
    
    
}
