import Foundation
import GCDWebServer

internal class FrontendProxyRequestMapper {
    
    // MARK: - Internal
    
    internal func map(method method: String!, url: NSURL!, headers: [NSObject: AnyObject]!, path: String!, query: [NSObject: AnyObject]!, proxyResources: [ProxyResource]) -> GCDWebServerRequest? {
        return proxyResources.flatMap { [weak self] (resource) -> GCDWebServerRequest? in
            return self?.request(withResource: resource, method: method, url: url, headers: headers, path: path, query: query)
        }.first
    }
    
    // MARK: - Private
    
    private func request(withResource resource: ProxyResource, method: String!, url: NSURL!, headers: [NSObject: AnyObject]!, path: String!, query: [NSObject: AnyObject]!) -> GCDWebServerRequest? {
        guard let url = url else { return nil }
        guard let path = path else { return nil }
        if !path.containsString(resource.path) { return nil }
        let proxiedUrl = NSURL(string: resource.url)!
        return GCDWebServerRequest(method: method,
                                   url: proxiedUrl,
                                   headers: headers,
                                   path: path,
                                   query: query)
        
    }
    
}
