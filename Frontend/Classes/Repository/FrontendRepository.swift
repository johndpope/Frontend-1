import Foundation

internal struct FrontendRepository {
    
    // MARK: - Attributes
    
    internal let url: String
    
    // MARK: - Init
    
    init(url: NSURL) {
        self.url = url.absoluteString
    }
    
    // MARK: - Internal
    
    internal func file(atPath path: String) -> NSData? {
        let localPath = NSString(string: self.url).stringByAppendingPathComponent(path)
        return NSData(contentsOfFile: localPath)
    }
    
}