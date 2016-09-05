import Foundation
import Quick
import Nimble
import GCDWebServer

@testable import Frontend

class FrontendServerSpec: QuickSpec {
    override func spec() {
        var subject: FrontendServer!
        var server: MockGCDServer!
        var path: String!
        var proxyResources: [ProxyResource]!
        var port: UInt!
        var configurator: MockFrontendConfigurator!
        
        beforeEach {
            server = MockGCDServer()
            path = "/path"
            proxyResources = []
            port = 8080
            configurator = MockFrontendConfigurator(proxyResources: [])
            subject = FrontendServer(path: path, port: port, proxyResources: proxyResources, server: server, configurator: configurator)
        }
        
        describe("-start") {
            var started: Bool!
            
            beforeEach {
                started = subject.start()
            }
            
            it("should return the correct value") {
                expect(started) == true
            }
            
            it("should start with the correct port") {
                expect(server.startedPort) == port
            }
            
            it("should start with no bonjour name") {
                expect(server.startedBonjourName).to(beNil())
            }
        
            it("should configure the frontend with the correct directory path") {
                expect(configurator.configuredDirectoryPath) == path
            }
            
            it("should configure the frontend with the correct server") {
                expect(configurator.configuredServer).to(beIdenticalTo(subject.server))
            }
        }
    }
}

// MARK: - Mock

private class MockGCDServer: GCDWebServer {
    
    var startedPort: UInt!
    var startedBonjourName: String!
    
    private override func startWithPort(port: UInt, bonjourName name: String!) -> Bool {
        self.startedPort = port
        self.startedBonjourName = name
        return true
    }

}

private class MockFrontendConfigurator: FrontendConfigurator {
    
    var configuredDirectoryPath: String!
    var configuredServer: GCDWebServer!
    
    private override func configure(directoryPath directoryPath: String, server: GCDWebServer) {
        self.configuredDirectoryPath = directoryPath
        self.configuredServer = server
    }
}