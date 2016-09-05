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
                    expect(proxyRequestMapper.mappedURL) == NSURL(string: "url")!
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
    var mappedURL: NSURL!
    var mappedHeaders: [NSObject : AnyObject]!
    var mappedPath: String!
    var mappedQuery: [NSObject: AnyObject]!
    
    private override func map(method method: String!, url: NSURL!, headers: [NSObject : AnyObject]!, path: String!, query: [NSObject : AnyObject]!, proxyResource: [ProxyResource]) -> GCDWebServerRequest? {
        self.mappedMethod = method
        self.mappedURL = url
        self.mappedHeaders = headers
        self.mappedPath = path
        self.mappedQuery = query
        return GCDWebServerRequest(method: "GET", url: NSURL(string: "url")!, headers: [:], path: "pepi", query: [:])
    }
    
}

private class MockRequestDispatcher: FrontendRequestDispatcher {
    
    var dispatchedRequest: GCDWebServerRequest!
    
    private override func dispatch(request request: GCDWebServerRequest, completion: GCDWebServerCompletionBlock) {
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
    
    private override func addGETHandlerForBasePath(basePath: String!, directoryPath: String!, indexFilename: String!, cacheAge: UInt, allowRangeRequests: Bool) {
        self.getHandlerBasePath = basePath
        self.getHandlerDirectoryPath = directoryPath
        self.getHandlerIndexFileName = indexFilename
        self.getHandlerCacheAge = cacheAge
        self.getHandlerAllowRangeRequests = allowRangeRequests
    }
    
    private override func addHandlerWithMatchBlock(matchBlock: GCDWebServerMatchBlock!, asyncProcessBlock processBlock: GCDWebServerAsyncProcessBlock!) {
        self.returnedRequest = matchBlock("GET", NSURL(string: "url")!, [:], "path", [:])
        processBlock(self.returnedRequest, { _ in })
    }
}