import Foundation
import Zip

internal class FrontendFileManager {
    
    // MARK: - Attributes
    
    internal let path: String
    internal let zipPath: String
    internal let fileManager: FileManager
    internal let zipExtractor: ZipExtractor
    
    // MARK: - Init
    
    internal init(path: String, zipPath: String, fileManager: FileManager = FileManager.default, zipExtractor: ZipExtractor = ZipExtractor()) {
        self.path = path
        self.zipPath = zipPath
        self.fileManager = fileManager
        self.zipExtractor = zipExtractor
    }
    
    // MARK: - Internal
    
    internal func currentPath() -> String {
        return NSString(string: self.path).appendingPathComponent("Current")
    }
    
    internal func enqueuedPath() -> String {
        return NSString(string: self.path).appendingPathComponent("Enqueued")
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
        if !self.enqueuedAvailable() { throw FrontendFileManagerError.notAvailable }
        try self.fileManager.removeItem(atPath: self.currentPath())
        try self.fileManager.moveItem(atPath: self.enqueuedPath(), toPath: self.currentPath())
    }
    
    internal func replaceWithZipped() throws {
        let zipFilePath: URL = URL(fileURLWithPath: self.zipPath)
        let destinationPath: URL = URL(fileURLWithPath: self.currentPath())
        try self.zipExtractor.unzipFile(zipFilePath: zipFilePath, destination: destinationPath, overwrite: true, password: nil, progress: nil)
    }
    
    // MARK: - Private
    
    fileprivate func manifest(atPath path: String) -> Manifest? {
        let manifestPath = NSString(string: path).appendingPathComponent(Manifest.LocalName)
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: manifestPath)) else { return nil }
        return try? Manifest(data: data)
    }
    
    fileprivate func frontend(atPath path: String) -> Bool {
        guard let manifest = self.manifest(atPath: path) else { return false }
        for file in manifest.files {
            let filePath = NSString(string: path).appendingPathComponent(file.path)
            if !self.fileManager.fileExists(atPath: filePath) {
                return false
            }
        }
        return true
    }
    
}
