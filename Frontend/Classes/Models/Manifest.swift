import Foundation
import SwiftyJSON
/**
 *  Manifest
 */
internal struct Manifest {
    
    /**
     *  Manifes File
     */
    internal struct File {
        internal let path: String
        internal let hash: String
    }
    
    // MARK: - Attributes
    
    internal let baseUrl: String
    internal let commit: String?
    internal let buildAuthor: String?
    internal let gitBranch: String?
    internal let timestamp: Int?
    internal let files: [Manifest.File]
    
}

// MARK: - Extension - JSON Inits

internal extension Manifest {
    
    init(baseUrl: String, json:JSON) {
        self.baseUrl = baseUrl
        self.commit = json["commit"].stringValue
        self.buildAuthor = json["build_author"].stringValue
        self.gitBranch = json["git_branch"].stringValue
        self.timestamp = json["timestamp"].intValue
        var files: [Manifest.File] = []
        for element in json["files"].enumerate() {
            let path: String = element.element.0
            let hash: String = element.element.1.stringValue
            let file: File = File(path: path, hash: hash)
            files.append(file)
        }
        self.files = files
    }
    
    init(json: JSON) {
        let baseUrl = json["base_url"].string!
        self.init(baseUrl: baseUrl, json: json)
    }
    
}