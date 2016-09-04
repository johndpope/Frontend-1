import Foundation
import GCDWebServer

internal class FrontendServer {
    
    // MARK: - Attributes
    
    private let path: String
    private let port: UInt
    private let proxyResources: [ProxyResource]
    internal let server: GCDWebServer
    
    // MARK: - Init
    
    internal convenience init(path: String, port: UInt, proxyResources: [ProxyResource]) {
        let server = GCDWebServer()
        self.init(path: path, port: port, proxyResources: proxyResources, server: server)
    }
    
    internal init(path: String, port: UInt, proxyResources: [ProxyResource], server: GCDWebServer) {
        self.path = path
        self.port = port
        self.proxyResources = proxyResources
        self.server = server
    }
    
    // MARK: - Internal
    
    internal func start() -> Bool {
        self.setup()
        return self.server.startWithPort(self.port, bonjourName: nil)
    }
    
    // MARK: - Private
    
    private func setup() {
        self.server.addGETHandlerForBasePath("/", directoryPath: self.path, indexFilename: "index.html", cacheAge: 3600, allowRangeRequests: true)
        for proxyResource in self.proxyResources {
            self.server.addHandlerWithMatchBlock({ (method, url, headers, path, query) -> GCDWebServerRequest! in
                if path.containsString(proxyResource.path) {
                    return GCDWebServerRequest(method: method, url: url, headers: headers, path: path, query: query)
                }
                return nil
            }, asyncProcessBlock: { (request, completionBlock) in
                //TODO
            })
        }
    }
    
}