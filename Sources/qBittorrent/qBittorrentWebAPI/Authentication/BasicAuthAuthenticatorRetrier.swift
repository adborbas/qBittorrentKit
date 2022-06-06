import Foundation
import Alamofire

enum AuthError: Error {
    case forbidden
}

class BasicAuthAuthenticatorRetrier: RequestInterceptor {
    private let credentials: BasicAuthCredentials
    private var retryCount = 0
    
    init(credentials: BasicAuthCredentials) {
        self.credentials = credentials
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard retryCount == 0 else {
            return completion(.doNotRetryWithError(AuthError.forbidden))
        }
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 else {
            return completion(.doNotRetry)
        }
        
        guard let url = request.request?.url,
              let baseURL = sidCookieURL(from: url) else {
            return completion(.doNotRetry)
        }
        
        refreshAuthCookie(url: baseURL, for: session) { [weak self] error in
            guard let strongSelf = self else {
                completion(.doNotRetry)
                return
            }
            
            if let error = error {
                completion(.doNotRetryWithError(error))
            }
            strongSelf.retryCount += 1
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
}
