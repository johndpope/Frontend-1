import Foundation

public enum FrontendManifestError: ErrorType {
    case InvalidManifest(String)
    case UnconvertibleJSON
}

public enum FrontendFileManagerError: ErrorType {
    case NotAvailable
}

public enum FrontendControllerError: ErrorType, Equatable {
    case AlreadyDownloading
    case NoFrontendAvailable
}