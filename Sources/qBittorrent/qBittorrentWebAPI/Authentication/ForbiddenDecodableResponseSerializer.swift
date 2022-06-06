import Foundation
import Alamofire

class ForbiddenDecodableResponseSerializer<T: Decodable>: ResponseSerializer {
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
