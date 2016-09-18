import Foundation
import Quick
import Nimble
import GCDWebServer

@testable import Frontend

class FrontendRequestDispatcherSpec: QuickSpec {
    override func spec() {

        var session: MockSession!
        var dataTask: MockSessionDataTask!
        var response: GCDWebServerResponse!
        var responseMapper: MockResponseMapper!
        var request: NSURLRequest!
        var requestMapper: MockRequestMapper!
        var subject: FrontendRequestDispatcher!
        
        beforeEach {
            dataTask = MockSessionDataTask()
            session = MockSession()
            session.dataTask = dataTask
            response = GCDWebServerResponse()
            responseMapper = MockResponseMapper()
            responseMapper.response = response
            request = NSURLRequest()
            requestMapper = MockRequestMapper()
            requestMapper.request = request
            subject = FrontendRequestDispatcher(requestMapper: requestMapper,
                responseMapper: responseMapper,
                session: session)
        }
        
        describe("-dispatch:request:completion") {
            var dispatcherResponse: GCDWebServerResponse!
            
            beforeEach {
                subject.dispatch(request: GCDWebServerRequest(), completion: { (response) in
                    dispatcherResponse = response
                })
            }
            
            it("should complete with the correct response") {
                expect(dispatcherResponse).to(beIdenticalTo(response))
            }
        }
    }
}


// MARK: - Mocks

private class MockRequestMapper: FrontendRequestMapper {
    
    var request: NSURLRequest!
    
    private override func map(request request: GCDWebServerRequest) -> NSURLRequest {
        return self.request
    }
}

private class MockResponseMapper: FrontendResponseMapper {
    
    var response: GCDWebServerResponse!
    
    private override func map(data data: NSData?, response: NSURLResponse?, error: NSError?) -> GCDWebServerResponse {
        return self.response
    }
}

private class MockSession: NSURLSession {
    
    var dataTask: MockSessionDataTask!
    
    private override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        completionHandler(nil, NSURLResponse(), nil)
        return dataTask

    }
    
}

private class MockSessionDataTask: NSURLSessionDataTask {
    
    var resumed: Bool = false
    
    private override func resume() {
        self.resumed = true
    }
}