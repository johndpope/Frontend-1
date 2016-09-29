import Foundation
import GCDWebServer

internal class FrontendResponseMapper {
    
    internal func map(data data: Data?, response: URLResponse?, error: Error?) -> GCDWebServerResponse {
        let httpUrlResponse = (response as? HTTPURLResponse)
        let contentType = httpUrlResponse?.allHeaderFields["Content-Type"] as? String ?? ""
        var response: GCDWebServerDataResponse!
        if let data = data {
            response = GCDWebServerDataResponse(data: data, contentType: contentType)
        } else {
            response = GCDWebServerDataResponse()
        }
        //TODO: What if Error?
        //TODO: Update the source url?
        if let statusCode = httpUrlResponse?.statusCode {
            response?.statusCode = statusCode
        }
        for header in (httpUrlResponse?.allHeaderFields ?? [:]).keys {
            response.setValue(httpUrlResponse!.allHeaderFields[header] as! String!, forAdditionalHeader: header as! String)
        }
        return response
    }
    
}
