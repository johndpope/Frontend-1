import Foundation

public struct ProxyResource: Equatable {
    
    // MARK: - Attributes
    
    internal let path: String
    internal let url: String
    
    // MARK: - Init
    
    public init(path: String, url: String) {
        self.path = path
        self.url = url
    }
    
}

public func == (lhs: ProxyResource, rhs: ProxyResource) -> Bool {
    return lhs.path == rhs.path && lhs.url == rhs.url
}