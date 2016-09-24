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
        var request: URLRequest!
        var requestMapper: MockRequestMapper!
        var subject: FrontendRequestDispatcher!
        
        beforeEach {
            dataTask = MockSessionDataTask()
            session = MockSession()
            session.dataTask = dataTask
            response = GCDWebServerResponse()
            responseMapper = MockResponseMapper()
            responseMapper.response = response
            request = URLRequest(url: URL(string: "test://test")!)
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
    
    var request: URLRequest!
    
    fileprivate override func map(request: GCDWebServerRequest) -> URLRequest {
        return self.request
    }
}

private class MockResponseMapper: FrontendResponseMapper {
    
    var response: GCDWebServerResponse!
    
    fileprivate override func map(data: Data?, response: URLResponse?, error: Error?) -> GCDWebServerResponse {
        return self.response
    }
}

private class MockSession: URLSession {
    
    var dataTask: MockSessionDataTask!
    
    fileprivate override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, URLResponse(), nil)
        return dataTask

    }
    
}

private class MockSessionDataTask: URLSessionDataTask {
    
    var resumed: Bool = false
    
    fileprivate override func resume() {
        self.resumed = true
    }
}
