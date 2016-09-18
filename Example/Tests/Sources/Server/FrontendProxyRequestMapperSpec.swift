import Foundation
import Quick
import Nimble
import GCDWebServer

@testable import Frontend

class FrontendProxyRequestMapperSpec: QuickSpec {
    override func spec() {
        
        var subject: FrontendProxyRequestMapper!
        var resources: [ProxyResource]!
        var request: GCDWebServerRequest!
        
        beforeEach {
            subject = FrontendProxyRequestMapper()
            resources = [ProxyResource(path: "/admin", url: "https://remote.com")]
        }
        
        context("when the url is nil") {
            beforeEach {
                request = subject.map(method: "GET", url: nil, headers: nil, path: nil, query: nil, proxyResources: resources)
            }
            it("it shouldn't return any request") {
                expect(request).to(beNil())
            }
        }
        
        context("when the path is nil") {
            beforeEach {
                request = subject.map(method: "GET", url: NSURL(string: "https://test.com")!, headers: nil, path: nil, query: nil, proxyResources: resources)
            }
            it("it shouldn't return any request") {
                expect(request).to(beNil())
            }
        }
        
        context("when the path is not handled by any of the proxy resources") {
            beforeEach {
                request = subject.map(method: "GET", url: NSURL(string: "https://127.0.0.1"), headers: nil, path: "/test", query: nil, proxyResources: resources)
            }
            it("shouldn't return any request") {
                expect(request).to(beNil())
            }
        }
        
        context("when the path is supported by one of the handlers") {
            beforeEach {
                request = subject.map(method: "GET", url: NSURL(string: "https://127.0.0.1"), headers: ["key": "value"], path: "/admin/test/test2", query: ["key2": "value2"], proxyResources: resources)
            }
            
            it("should proxy the request with the correct method") {
                expect(request.method) == "GET"
            }
            
            it("should proxy the request with the correct url") {
                expect(request.URL.absoluteString) == resources.first?.url
            }
            
            it("should proxy the request with the correct headers") {
                expect(request.headers as? [String: String]) == ["key": "value"]
            }
            
            it("should proxy the request with the correct query") {
                expect(request.query as? [String: String]) == ["key2": "value2"]
            }
        }
        
    }
}