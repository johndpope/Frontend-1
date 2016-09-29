import Foundation
import Quick
import Nimble
import GCDWebServer

@testable import Frontend

class FrontendRequestMapperSpec: QuickSpec {
    override func spec() {
       
        var sourceRequest: GCDWebServerRequest!
        var outputRequest: URLRequest!
        var subject: FrontendRequestMapper!
        
        beforeEach {
            sourceRequest = GCDWebServerRequest(method: "GET", url: URL(string: "http://test.com"), headers: ["a": "b"], path: "/path", query: ["c": "d"])
            subject = FrontendRequestMapper()
            outputRequest = subject.map(request: sourceRequest)
        }
        
        it("should have the correct http method") {
            expect(outputRequest.httpMethod) == "GET"
        }
        
        it("should have the correct url") {
            expect(outputRequest.url?.absoluteString) == "http://test.com/path"
        }
        
        it("should have the correct headers") {
            expect(outputRequest.allHTTPHeaderFields! as [String: String]) == ["a": "b"]
        }
        
        it("should have the correct body") {
            let bodyData = outputRequest.httpBody!
            let bodyJson = try! JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: String]
            expect(bodyJson) == ["c": "d"]
        }
        
    }
}
