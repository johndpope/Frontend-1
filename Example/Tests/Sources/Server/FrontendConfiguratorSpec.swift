import Foundation
import Quick
import Nimble
import GCDWebServer

@testable import Frontend

class FrontendConfiguratorSpec: QuickSpec {
    override func spec() {
        
        var server: MockGCDServer!
        var path: String!
        var subject: FrontendConfigurator!
        var proxyRequestMapper: MockProxyRequestMapper!
        var requestDispatcher: MockRequestDispatcher!
        
        beforeEach {
            server = MockGCDServer()
            path = "path"
            proxyRequestMapper = MockProxyRequestMapper()
            requestDispatcher = MockRequestDispatcher()
            subject = FrontendConfigurator(proxyResources: [], proxyRequestMapper: proxyRequestMapper, requestDispatcher: requestDispatcher)
        }
        
        describe("-configure:directoryPath:server") {
            beforeEach {
                subject.configure(directoryPath: path, server: server)
            }
            describe("local") {
                it("should add a get handler with the correct base path") {
                    expect(server.getHandlerBasePath) == "/"
                }
                it("should add  a get handler with the correct directory path") {
                    expect(server.getHandlerDirectoryPath) == path
                }
                it("should add a get handler with the correct index file name") {
                    expect(server.getHandlerIndexFileName) == "index.html"
                }
                it("should add a get handler with the correct cache age") {
                    expect(server.getHandlerCacheAge) == 3600
                }
                it("should add a get handler with the correct allowRangeRequests") {
                    expect(server.getHandlerAllowRangeRequests) == true
                }
            }
            describe("remote") {
                it("should map the correct method") {
                    expect(proxyRequestMapper.mappedMethod) == "GET"
                }
                it("should map the correct url") {
                    expect(proxyRequestMapper.mappedURL) == URL(string: "url")!
                }
                it("should map the correct headers") {
                    expect(proxyRequestMapper.mappedHeaders as? [String: String]) == [:]
                }
                it("should map the correct path") {
                    expect(proxyRequestMapper.mappedPath) == "path"
                }
                it("should map the correct query") {
                    expect(proxyRequestMapper.mappedQuery as? [String: String]) == [:]
                }
                it("should return the request") {
                    expect(server.returnedRequest).toNot(beNil())
                }
                it("should dispatch the request") {
                    expect(requestDispatcher.dispatchedRequest).to(beIdenticalTo(server.returnedRequest))
                }
            }
        }
    }
}

// MARK: - Mock

private class MockProxyRequestMapper: FrontendProxyRequestMapper {
    
    var mappedMethod: String!
    var mappedURL: URL!
    var mappedHeaders: [AnyHashable: Any]!
    var mappedPath: String!
    var mappedQuery: [AnyHashable: Any]!

    fileprivate override func map(method: String!, url: URL!, headers: [AnyHashable : Any]!, path: String!, query: [AnyHashable : Any]!, proxyResources: [ProxyResource]) -> GCDWebServerRequest? {
        self.mappedMethod = method
        self.mappedURL = url
        self.mappedHeaders = headers
        self.mappedPath = path
        self.mappedQuery = query
        return GCDWebServerRequest(method: "GET", url: URL(string: "url")!, headers: [:], path: "pepi", query: [:])
    }
    
}

private class MockRequestDispatcher: FrontendRequestDispatcher {
    
    var dispatchedRequest: GCDWebServerRequest!
    
    fileprivate override func dispatch(request: GCDWebServerRequest, completion: @escaping GCDWebServerCompletionBlock) {
        self.dispatchedRequest = request
    }

}

private class MockGCDServer: GCDWebServer {
    
    var getHandlerBasePath: String!
    var getHandlerDirectoryPath: String!
    var getHandlerIndexFileName: String!
    var getHandlerCacheAge: UInt!
    var getHandlerAllowRangeRequests: Bool!
    
    var returnedRequest: GCDWebServerRequest!
    
    fileprivate override func addGETHandler(forBasePath basePath: String!, directoryPath: String!, indexFilename: String!, cacheAge: UInt, allowRangeRequests: Bool) {
        self.getHandlerBasePath = basePath
        self.getHandlerDirectoryPath = directoryPath
        self.getHandlerIndexFileName = indexFilename
        self.getHandlerCacheAge = cacheAge
        self.getHandlerAllowRangeRequests = allowRangeRequests
    }
    
    fileprivate override func addHandler(match matchBlock: GCDWebServerMatchBlock!, asyncProcessBlock processBlock: GCDWebServerAsyncProcessBlock!) {
        self.returnedRequest = matchBlock("GET", URL(string: "url")!, [:], "path", [:])
        processBlock(self.returnedRequest, { _ in })
    }
}
