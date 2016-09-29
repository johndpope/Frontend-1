import Foundation
import Quick
import Nimble
import GCDWebServer

@testable import Frontend

class FrontendresponseMapperSpec: QuickSpec {
    override func spec() {
        
        var response: HTTPURLResponse!
        var data: Data!
        var error: NSError!
        var subject: FrontendResponseMapper!
        var output: GCDWebServerResponse!
        
        beforeEach {
            response = HTTPURLResponse(url: URL(string:"http://test.com")!, statusCode: 25, httpVersion: "2.2", headerFields: ["a": "b", "content-type": "jpg"])
            subject = FrontendResponseMapper()
            data = try! JSONSerialization.data(withJSONObject: ["c": "d"], options: [])
            error = NSError(domain: "", code: -1, userInfo: nil)
            output = subject.map(data: data, response: response, error: error)
        }
        
        it("should use the correct data") {
            let outputData = try! output.readData()
            let json = try! JSONSerialization.jsonObject(with: outputData, options: []) as? [String: String]
            expect(json?["c"]) == "d"
        }
        
        it("should copy the content type") {
            expect(output.contentType) == "jpg"
        }
        
        it("should copy the status code") {
            expect(output.statusCode) == 25
        }
        
    }
}
