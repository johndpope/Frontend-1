import Foundation

public enum FrontendManifestError: Error {
    case invalidManifest(String)
    case unconvertibleJSON
}

public enum FrontendFileManagerError: Error {
    case notAvailable
}

public enum FrontendControllerError: Error, Equatable {
    case alreadyDownloading
    case noFrontendAvailable
}
