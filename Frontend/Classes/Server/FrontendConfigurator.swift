import Foundation
import GCDWebServer

internal class FrontendConfigurator {
    
    // MARK: - Properties
    
    internal let proxyRequestMapper: FrontendProxyRequestMapper
    internal let proxyResources: [ProxyResource]
    internal let requestDispatcher: FrontendRequestDispatcher
    
    // MARK: - Init
    
    internal init(proxyResources: [ProxyResource],
                  proxyRequestMapper: FrontendProxyRequestMapper = FrontendProxyRequestMapper(),
                  requestDispatcher: FrontendRequestDispatcher = FrontendRequestDispatcher()) {
        self.proxyResources = proxyResources
        self.proxyRequestMapper = proxyRequestMapper
        self.requestDispatcher = requestDispatcher
    }
    
    // MARK: - Internal
    
    internal func configure(directoryPath directoryPath: String, server: GCDWebServer) {
        self.configureLocal(directoryPath: directoryPath, server: server)
        self.configureProxy(server: server)
    }
    
    // MARK: - Private
    
    private func configureLocal(directoryPath directoryPath: String, server: GCDWebServer) {
        server.addGETHandler(forBasePath: "/", directoryPath: directoryPath, indexFilename: "index.html", cacheAge: 3600, allowRangeRequests: true)
    }
    
    private func configureProxy(server server: GCDWebServer) {
        server.addHandler(match: { (method, url, headers, path, query) -> GCDWebServerRequest? in
            return self.proxyRequestMapper.map(method: method, url: url, headers: headers, path: path, query: query, proxyResources: self.proxyResources)
            return GCDWebServerRequest()
        }) { (request, completion) in
            self.requestDispatcher.dispatch(request: request!, completion: completion!)
        }
    }
}
