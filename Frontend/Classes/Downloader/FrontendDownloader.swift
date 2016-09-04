import Foundation

internal class FrontendDownloader {
    
    // MARK: - Properties
    
    internal let session: NSURLSession
    
    // MARK: - Init
    
    internal init(session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())) {
        self.session = session
    }
    
    // MARK: - Internal
    
    internal func download(manifestUrl manifestUrl: String, baseUrl: String, manifestMapper: ManifestMapper, downloadPath: String, progress: (downloaded: Int, total: Int) -> Void, completion: NSError? -> Void) {
        self.downloadManifest(manifestUrl: manifestUrl, baseUrl: baseUrl, manifestMapper: manifestMapper) { (manifest, error) in
            if let error = error { completion(error)
            } else if let manifest = manifest {
                self.downloadFiles(manifest: manifest,
                                   downloadPath: downloadPath,
                                   completion: completion,
                                   progress: progress)
            }
        }
    }
    
    // MARK: - Private
    
    private func downloadFiles(manifest manifest: Manifest, downloadPath: String, completion: NSError? -> Void, progress: (downloaded: Int, total: Int) -> Void) {
        var downloaded: [Manifest.File] = []
        let files: [Manifest.File] = manifest.files
        for file in files {
            // TODO
            /*
             1. If the file is available, copy it
             2. Else, download it

 */
        }
    }
    
    private func downloadManifest(manifestUrl manifestUrl: String, baseUrl: String, manifestMapper: ManifestMapper, completion: (Manifest?, NSError?) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: manifestUrl)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        self.session.dataTaskWithRequest(request) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                completion(manifestMapper(baseUrl)(json), nil)
            } catch {
                completion(nil, error as NSError)
            }
        }.resume()
    }
    
}