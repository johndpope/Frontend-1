import Foundation
import GCDWebServer

internal class FrontendRequestDispatcher {
    
    // MARK: - Attributes
    
    internal let requestMapper: FrontendRequestMapper
    internal let responseMapper: FrontendResponseMapper
    internal let session: NSURLSession
    
    // MARK: - Init
    
    internal init(requestMapper: FrontendRequestMapper = FrontendRequestMapper(),
        responseMapper: FrontendResponseMapper = FrontendResponseMapper(),
                  session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())) {
        self.requestMapper = requestMapper
        self.responseMapper = responseMapper
        self.session = session
    }
    
    // MARK: - Internal
    
    internal func dispatch(request request: GCDWebServerRequest, completion: GCDWebServerCompletionBlock) {
        self.session.dataTaskWithRequest(self.requestMapper.map(request: request)) { (data, response, error) in
            if let response = response {
                completion(self.responseMapper.map(data: data, response: response))
            }
        }
    }
   
}