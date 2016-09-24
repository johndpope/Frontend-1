import Foundation
import SwiftyJSON

public typealias ManifestMapper = (String) -> ((AnyObject) -> Manifest)

internal var DefaultManifestMapper: ManifestMapper = { baseUrl in
    return { input -> Manifest in
        let json = JSON(input)
        let commit = json["commit"].stringValue
        let buildAuthor = json["build_author"].stringValue
        let gitBranch = json["git_branch"].stringValue
        let timestamp = json["timestamp"].intValue
        var files: [Manifest.File] = []
        for element in json["files"].enumerated() {
            let path: String = element.element.0
            let hash: String = element.element.1.stringValue
            let file: Manifest.File = Manifest.File(path: path, hash: hash)
            files.append(file)
        }
        return Manifest(baseUrl: baseUrl,
                        commit: commit,
                        buildAuthor: buildAuthor,
                        gitBranch: gitBranch,
                        timestamp: timestamp,
                        files: files)
    }
}
