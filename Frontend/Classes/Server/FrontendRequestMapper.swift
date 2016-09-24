import Foundation
import GCDWebServer

internal class FrontendRequestMapper {
    
    internal func map(request: GCDWebServerRequest) -> URLRequest {
        var urlRequest: URLRequest = URLRequest(url:  request.url.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers as? [String: String]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.query, options: [])
        return urlRequest
    }
    
}
