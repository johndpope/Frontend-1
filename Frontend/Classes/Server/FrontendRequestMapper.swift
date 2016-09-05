import Foundation
import GCDWebServer

internal class FrontendRequestMapper {
    
    internal func map(request request: GCDWebServerRequest) -> NSURLRequest {
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest()
        urlRequest.URL = request.URL.URLByAppendingPathComponent(request.path)
        urlRequest.HTTPMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers as? [String: String]
        urlRequest.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(request.query, options: [])
        return urlRequest.copy() as! NSURLRequest
    }
    
}