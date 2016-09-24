import Foundation

internal class FrontendDownloader {
    
    // MARK: - Properties
    
    internal let session: URLSession
    
    // MARK: - Init
    
    internal init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    // MARK: - Internal
    
    internal func download(manifestUrl: String, baseUrl: String, manifestMapper: @escaping ManifestMapper, downloadPath: String, progress: @escaping (_ downloaded: Int, _ total: Int) -> Void, completion: @escaping (Error?) -> Void) {
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
    
    fileprivate func downloadFiles(manifest: Manifest, downloadPath: String, completion: (NSError?) -> Void, progress: (_ downloaded: Int, _ total: Int) -> Void) {
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
    
    fileprivate func downloadManifest(manifestUrl: String, baseUrl: String, manifestMapper: @escaping ManifestMapper, completion: @escaping (Manifest?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: URL(string: manifestUrl)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completion(manifestMapper(baseUrl)(json as AnyObject), nil)
            } catch {
                completion(nil, error as NSError)
            }
        }.resume()
    }
    
}
