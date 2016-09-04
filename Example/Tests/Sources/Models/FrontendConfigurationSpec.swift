import Foundation
import Quick
import Nimble

@testable import Frontend

class FrontendConfigurationSpec: QuickSpec {
    override func spec() {
        
        var manifestUrl: String!
        var baseUrl: String!
        var port: UInt!
        var proxyResources: [ProxyResource]!
        var subject: FrontendConfiguration!
        var zipPath: String!
        
        beforeEach {
            manifestUrl = "manifestUrl"
            baseUrl = "baseUrl"
            port = 8080
            proxyResources = [ProxyResource(path: "path", url: "url")]
            zipPath = "path"
        }
        
        describe("-init") {
            
            beforeEach {
                subject = FrontendConfiguration(manifestUrl: manifestUrl,
                    baseUrl: baseUrl,
                    port: port,
                    zipPath: zipPath,
                    proxyResources: proxyResources)
            }
            
            it("should set the correct manifestUrl") {
                expect(subject.manifestUrl) == manifestUrl
            }
            
            it("should set the correct baseUrl") {
                expect(subject.baseUrl) == baseUrl
            }
            
            it("should have the correct proxyResources") {
                expect(subject.proxyResources) == proxyResources
            }
        
            it("should set the correct localPath") {
                expect(subject.localPath) == FrontendConfiguration.defaultDirectory()
            }
            
            it("should have the correct zipPath") {
                expect(subject.zipPath) == zipPath
            }
        }
        
    }
}