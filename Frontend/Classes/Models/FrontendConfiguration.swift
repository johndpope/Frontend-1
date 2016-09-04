import Foundation

public struct FrontendConfiguration {
    
    // MARK: - Attributes
    
    internal let manifestUrl: String
    internal let baseUrl: String
    internal let localPath: String
    internal let port: UInt
    internal let proxyResources: [ProxyResource]
    internal let manifestMapper: ManifestMapper
    internal let zipPath: String
    
    // MARK: - Init
    
    public init(manifestUrl: String,
                baseUrl: String,
                port: UInt,
                zipPath: String,
                proxyResources: [ProxyResource] = [],
                localPath: String = FrontendConfiguration.defaultDirectory(),
                manifestMapper: ManifestMapper = DefaultManifestMapper) {
        self.manifestUrl = manifestUrl
        self.baseUrl = baseUrl
        self.localPath = localPath
        self.port = port
        self.proxyResources = proxyResources
        self.manifestMapper = manifestMapper
        self.zipPath = zipPath
    }
    
    // MARK: - Private
    
    internal static func defaultDirectory() -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return NSString(string: documentsDirectory).stringByAppendingPathComponent("Frontend")
    }
    
}