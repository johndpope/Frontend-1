import Foundation
import Zip

internal class ZipExtractor {
    
    internal func unzipFile(zipFilePath: NSURL, destination: NSURL, overwrite: Bool, password: String?, progress: ((progress: Double) -> ())?) throws {
        try Zip.unzipFile(zipFilePath, destination: destination, overwrite: overwrite, password: password, progress: progress)
    }
    
}