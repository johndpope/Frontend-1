import Foundation
import SwiftyJSON

public struct Manifest {
    
    public struct File: Equatable {
        
        public let path: String
        public let hash: String
        
        public init(path: String, hash: String) {
            self.path = path
            self.hash = hash
        }
    }
    
    // MARK: - Attributes
    
    public let baseUrl: String
    public let commit: String?
    public let buildAuthor: String?
    public let gitBranch: String?
    public let timestamp: Int?
    public let files: [Manifest.File]
    
    
    // MARK: - Init
    
    public init(baseUrl: String,
                commit: String?,
                buildAuthor: String?,
                gitBranch: String?,
                timestamp: Int?,
                files: [Manifest.File]) {
        self.baseUrl = baseUrl
        self.commit = commit
        self.buildAuthor = buildAuthor
        self.gitBranch = gitBranch
        self.timestamp = timestamp
        self.files = files
    }
    
}

public func == (lhs: Manifest.File, rhs: Manifest.File) -> Bool {
    return lhs.hash == rhs.hash && lhs.path == rhs.path
}

// MARK: - Manifest Extension (Data)

internal extension Manifest {
    
    internal static var LocalName: String = "app.json"
    
    internal init(data: Data) throws {
        let json = JSON(data: data)
        guard let baseUrl = json["base_url"].string else { throw FrontendManifestError.invalidManifest("Missing key: base_url") }
        let commit = json["commit"].string
        let buildAuthor = json["build_author"].string
        let gitBranch = json["git_branch"].string
        let timestamp = json["timestamp"].int
        let files = json["files"].arrayValue.flatMap { (json) -> Manifest.File? in
            guard let path = json["path"].string, let hash = json["hash"].string else { return nil }
            return Manifest.File(path: path, hash: hash)
        }
        self.init(baseUrl: baseUrl,
                        commit: commit,
                        buildAuthor: buildAuthor,
                        gitBranch: gitBranch,
                        timestamp: timestamp,
                        files: files)
    }
    
    internal func toData() throws -> Data {
        var dictionary = [String: AnyObject]()
        dictionary["base_url"] = self.baseUrl as AnyObject?
        if let commit = self.commit { dictionary["commit"] = commit as AnyObject? }
        if let buildAuthor = self.buildAuthor { dictionary["build_author"] = buildAuthor as AnyObject? }
        if let gitBranch = self.gitBranch { dictionary["git_branch"] = gitBranch as AnyObject? }
        if let timestamp = self.timestamp { dictionary["timestamp"] = timestamp as AnyObject? }
        var files: [[String: AnyObject]] = []
        self.files.forEach { file in
         files.append(["path": file.path as AnyObject, "hash": file.hash as AnyObject])
        }
        dictionary["files"] = files as AnyObject?
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: [])
        }
        catch {
            throw FrontendManifestError.unconvertibleJSON
        }
    }
    
}
