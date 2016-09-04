import Foundation
import Quick
import Nimble

@testable import Frontend

class FrontendControllerSpec: QuickSpec {
    override func spec() {
        
        var configuration: FrontendConfiguration!
        var fileManager: MockFileManager!
        var downloader: MockDownloader!
        var server: MockServer!
        var subject: FrontendController!
        
        beforeEach {
            configuration = FrontendConfiguration(manifestUrl: "manifestUrl", baseUrl: "baseURl", port: 8080, zipPath: "zipPath")
            fileManager = MockFileManager(path: configuration.localPath, zipPath: configuration.zipPath)
            downloader = MockDownloader()
            server = MockServer(path: fileManager.currentPath(), port: configuration.port, proxyResources: configuration.proxyResources)
            subject = FrontendController(configuration: configuration,
                fileManager: fileManager,
                downloader: downloader,
                server: server)
        }
        
        describe("-setup") {
            context("when the current frontend is not available") {
                beforeEach {
                    fileManager._currentAvailable = false
                    _ = try? subject.setup()
                }
                it("should replace the current with the zipped one") {
                    expect(fileManager.replacedWithZip) == true
                }
            }
            context("when the there's a current frontend and an enqueued available") {
                beforeEach {
                    fileManager._currentAvailable = true
                    fileManager._enqueuedAvailable = true
                    try! subject.setup()
                }
                it("should replace the current with the enqueued one") {
                    expect(fileManager.replacedWithEnqueued) == true
                }
            }
            context("if there's no frontend available") {
                beforeEach {
                    fileManager._currentAvailable = false
                }
                it("should throw a .NoFrontendAvailable") {
                    expect {
                        try subject.setup()
                    }.to(throwError(FrontendControllerError.NoFrontendAvailable))
                }
            }
            describe("download") {
                beforeEach {
                    fileManager._currentAvailable = true
                    try! subject.setup()
                }
                it("it should download with the correct manifest") {
                    expect(downloader.downloadManifestUrl) == configuration.manifestUrl
                }
                it("should download with the correct base url") {
                    expect(downloader.downloadBaseUrl) == configuration.baseUrl
                }
                it("should download with the correct download path") {
                    expect(downloader.downloadPath) == fileManager.enqueuedPath()
                }
            }
            
            describe("server") {
                beforeEach {
                    fileManager._currentAvailable = true
                    try! subject.setup()
                }
                it("should start the server") {
                    expect(server.started) == true
                }
            }
        }
        
        describe("-url") {
            it("should have the correct format") {
                expect(subject.url()) == "http://127.0.0.1:\(configuration.port)"
            }
        }
        
        describe("-available") {
            it("should return the correct status") {
                expect(subject.available()) == fileManager.currentAvailable()
            }
        }
        
        describe("-download:replacing:progress:completion") {
            context("when it errors") {
                it("should notify about the error") {
                    waitUntil(action: { (done) in
                        let error = NSError(domain: "", code: -1, userInfo: nil)
                        downloader.completionError = error
                        try! subject.download(replacing: false, progress: nil, completion: { (_error) in
                            expect(_error) == error
                            done()
                        })
                    })
                }
            }
            context("when it doesn't error") {
                it("shouldn't send any error back") {
                    waitUntil(action: { (done) in
                        try! subject.download(replacing: true, progress: nil, completion: { (_error) in
                            expect(_error).to(beNil())
                            done()
                        })
                    })
                }
                it("should replace if the frontend if it's specified") {
                    waitUntil(action: { (done) in
                        try! subject.download(replacing: true, progress: nil, completion: { (_error) in
                            expect(fileManager.replacedWithEnqueued) == true
                            done()
                        })
                    })
                }
            }
        }
    }
}

// MARK: - Mocks

private class MockFileManager: FrontendFileManager {
    
    var replacedWithZip: Bool = false
    var replacedWithEnqueued: Bool = false
    var _currentAvailable: Bool = false
    var _enqueuedAvailable: Bool = false
    
    private override func replaceWithZipped() throws {
        self.replacedWithZip = true
    }
    
    private override func replaceWithEnqueued() throws {
        self.replacedWithEnqueued = true
    }
    
    private override func currentAvailable() -> Bool {
        return self._currentAvailable
    }
    
    private override func enqueuedAvailable() -> Bool {
        return self._enqueuedAvailable
    }
}

private class MockDownloader: FrontendDownloader {
    
    var downloadManifestUrl: String!
    var downloadBaseUrl: String!
    var downloadPath: String!
    var completionError: NSError?

    private override func download(manifestUrl manifestUrl: String, baseUrl: String, manifestMapper: ManifestMapper, downloadPath: String, progress: (downloaded: Int, total: Int) -> Void, completion: NSError? -> Void) {
        self.downloadManifestUrl = manifestUrl
        self.downloadBaseUrl = baseUrl
        self.downloadPath = downloadPath
        completion(completionError)
    }
}

private class MockServer: FrontendServer {
    
    var started: Bool = false
    
    private override func start() -> Bool {
        self.started = true
        return true
    }
    
}
