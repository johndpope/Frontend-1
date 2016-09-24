import Foundation
import GCDWebServer

internal class FrontendRequestDispatcher {
    
    // MARK: - Attributes
    
    internal let requestMapper: FrontendRequestMapper
    internal let responseMapper: FrontendResponseMapper
    internal let session: URLSession
    
    // MARK: - Init
    
    internal init(requestMapper: FrontendRequestMapper = FrontendRequestMapper(),
        responseMapper: FrontendResponseMapper = FrontendResponseMapper(),
                  session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.requestMapper = requestMapper
        self.responseMapper = responseMapper
        self.session = session
    }
    
    // MARK: - Internal
    
    internal func dispatch(request request: GCDWebServerRequest, completion: @escaping GCDWebServerCompletionBlock) {
        self.session.dataTask(with: self.requestMapper.map(request: request)) { (data, response, error) in
            completion(self.responseMapper.map(data: data, response: response, error: error))
        }.resume()
    }
   
}
