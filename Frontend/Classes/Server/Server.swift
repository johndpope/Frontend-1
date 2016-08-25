import Foundation
import GCDWebServer

internal struct Server {
    
    // MARK: - Attributes
    
    private let url: String
    internal let server: GCDWebServer
    
    // MARK: - Init
    
    internal init(url: NSURL, server: GCDWebServer = GCDWebServer()) {
        self.url = url.absoluteString
        self.server = server
    }
    
    // MARK: - Internal
    
    internal func start() {
        self.server.start()
    }
}