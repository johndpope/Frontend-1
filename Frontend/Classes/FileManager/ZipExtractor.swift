import Foundation
import Zip

internal class ZipExtractor {
    
    internal func unzipFile(zipFilePath: URL, destination: URL, overwrite: Bool, password: String?, progress: ((_ progress: Double) -> ())?) throws {
        try Zip.unzipFile(zipFilePath, destination: destination, overwrite: overwrite, password: password, progress: progress)
    }
    
}
