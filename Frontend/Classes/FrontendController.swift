import Foundation

public typealias FrontendProgress = ((downloaded: Int, total: Int) -> Void)
public typealias FrontendCompletion =  ((NSError?) -> Void)

@objc public class FrontendController: NSObject {
    
    // MARK: - Attributes
    
    internal let configuration: FrontendConfiguration
    internal let fileManager: FrontendFileManager
    internal let downloader: FrontendDownloader
    internal let server: FrontendServer
    public private(set) var downloading: Bool = false
    
    // MARK: - Init
    
    convenience public init(configuration: FrontendConfiguration) {
        let fileManager = FrontendFileManager(path: configuration.localPath, zipPath: configuration.zipPath)
        let downloader = FrontendDownloader()
        let server = FrontendServer(path: fileManager.currentPath(), port: configuration.port, proxyResources: configuration.proxyResources)
        self.init(configuration: configuration,
                  fileManager: fileManager,
                  downloader: downloader,
                  server: server)
    }
    
    internal init(configuration: FrontendConfiguration,
                  fileManager: FrontendFileManager,
                  downloader: FrontendDownloader,
                  server: FrontendServer) {
        self.configuration = configuration
        self.fileManager = fileManager
        self.downloader = downloader
        self.server = server
    }
    
    // MARK: - Public
    
    public func setup() throws {
        if !self.fileManager.currentAvailable() {
            try self.fileManager.replaceWithZipped()
        }
        else if self.fileManager.enqueuedAvailable() {
            try self.fileManager.replaceWithEnqueued()
        }
        if !self.fileManager.currentAvailable() {
            throw FrontendControllerError.NoFrontendAvailable
        }
        try self.download(replacing: false)
        self.server.start()
    }
    
    public func url() -> String {
        return "http://127.0.0.1:\(self.configuration.port)"
    }
    
    public func available() -> Bool {
        return self.fileManager.currentAvailable()
    }
    
    public func download(replacing replace: Bool, progress: FrontendProgress? = nil, completion: FrontendCompletion? = nil) throws {
        if self.downloading {
            throw FrontendControllerError.AlreadyDownloading
        }
        self.downloader.download(manifestUrl: self.configuration.manifestUrl,
                                 baseUrl: self.configuration.baseUrl,
                                 manifestMapper: self.configuration.manifestMapper,
                                 downloadPath: self.fileManager.enqueuedPath(),
                                 progress: { (downloaded, total) in progress?(downloaded: downloaded, total: total)
        }) { [weak self] error in
            self?.downloading = false
            if !replace {
                completion?(error)
                return
            }
            do {
                try self?.fileManager.replaceWithEnqueued()
                completion?(nil)
            } catch {
                completion?(error as NSError)
            }
        }
    }
    
}
