import Foundation

internal class FrontendFileManager {
    
    // MARK: - Attributes
    
    internal let path: String
    internal let zipPath: String
    internal let fileManager: NSFileManager
    
    // MARK: - Init
    
    internal init(path: String, zipPath: String, fileManager: NSFileManager = NSFileManager.defaultManager()) {
        self.path = path
        self.zipPath = zipPath
        self.fileManager = fileManager
    }
    
    // MARK: - Internal
    
    internal func file(atPath path: String) -> NSData? {
        let localPath = NSString(string: self.path).stringByAppendingPathComponent(path)
        return NSData(contentsOfFile: localPath)
    }
    
    internal func currentPath() -> String {
        return NSString(string: self.path).stringByAppendingPathComponent("Current")
    }
    
    internal func enqueuedPath() -> String {
        return NSString(string: self.path).stringByAppendingPathComponent("Enqueued")
    }
    
    internal func currentFrontendManifest() -> Manifest? {
        return self.manifest(atPath: self.currentPath())
    }
    
    internal func enqueuedFrontendManifest() -> Manifest? {
        return self.manifest(atPath: self.enqueuedPath())
    }
    
    internal func currentAvailable() -> Bool {
        return self.frontend(atPath: self.currentPath())
    }
    
    internal func enqueuedAvailable() -> Bool {
        return self.frontend(atPath: self.enqueuedPath())
    }
    
    internal func replaceWithEnqueued() throws {
        if !self.enqueuedAvailable() { throw FrontendFileManagerError.NotAvailable }
        try self.fileManager.removeItemAtPath(self.currentPath())
        try self.fileManager.moveItemAtPath(self.enqueuedPath(), toPath: self.currentPath())
    }
    
    internal func replaceWithZipped() throws {
        //TODO
    }
    
    // MARK: - Private
    
    private func manifest(atPath path: String) -> Manifest? {
        let manifestPath = NSString(string: path).stringByAppendingPathComponent(Manifest.LocalName)
        guard let data = NSData(contentsOfFile: manifestPath) else { return nil }
        return try? Manifest(data: data)
    }
    
    private func frontend(atPath path: String) -> Bool {
        guard let manifest = self.manifest(atPath: path) else { return false }
        for file in manifest.files {
            let filePath = NSString(string: path).stringByAppendingPathComponent(file.path)
            if !self.fileManager.fileExistsAtPath(filePath) {
                return false
            }
        }
        return true
    }
    
}