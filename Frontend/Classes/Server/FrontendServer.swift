import Foundation
import GCDWebServer

internal class FrontendServer {
    
    // MARK: - Attributes
    
    private let path: String
    private let port: UInt
    private let proxyResources: [ProxyResource]
    internal let server: GCDWebServer
    internal let configurator: FrontendConfigurator
    
    // MARK: - Init
    
    internal convenience init(path: String, port: UInt, proxyResources: [ProxyResource]) {
        let server = GCDWebServer()!
        let configurator = FrontendConfigurator(proxyResources: proxyResources)
        self.init(path: path, port: port, proxyResources: proxyResources, server: server, configurator: configurator)
    }
    
    internal init(path: String, port: UInt, proxyResources: [ProxyResource], server: GCDWebServer, configurator: FrontendConfigurator) {
        self.path = path
        self.port = port
        self.proxyResources = proxyResources
        self.server = server
        self.configurator = configurator
    }
    
    // MARK: - Internal
    
    internal func start() -> Bool {
        self.configurator.configure(directoryPath: self.path, server: self.server)
        return self.server.start(withPort: self.port, bonjourName: nil)
    }
    
}
