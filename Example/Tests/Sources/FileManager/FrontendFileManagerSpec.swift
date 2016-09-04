import Foundation
import Quick
import Nimble
import Zip

@testable import Frontend

private class TestClass: NSObject {}

private func unzip(name name: String, path: String) {
    let url = NSBundle(forClass: TestClass.self).URLForResource(name, withExtension: "zip")
    try! Zip.unzipFile(url!, destination: NSURL(fileURLWithPath: path), overwrite: true, password: nil, progress: nil)
}

class FrontendFileManagerSpec: QuickSpec {
    override func spec() {
        
        var path: String!
        var zipPath: String!
        var fileManager: MockFileManager!
        var zipExtractor: MockZipExtractor!
        var subject: FrontendFileManager!
        
        beforeEach {
            path = FrontendConfiguration.defaultDirectory()
            zipPath = "zipPath"
            fileManager = MockFileManager()
            zipExtractor = MockZipExtractor()
            unzip(name: "Data", path: path)
            subject = FrontendFileManager(path: path, zipPath: zipPath, fileManager: fileManager, zipExtractor: zipExtractor)
        }
        
        describe("-currentPath") {
            it("should return the correct value") {
                expect(subject.currentPath()) == "\(path)/Current"
            }
        }
        
        describe("-enqueuedPath") {
            it("should return the correct value") {
                expect(subject.enqueuedPath()) == "\(path)/Enqueued"
            }
        }
        
        describe("-currentFrontendManifest") {
            it("should return the correct value") {
                expect(subject.currentFrontendManifest()).toNot(beNil())
            }
        }
        
        describe("-enqueuedFrontendManifest") {
            it("should return the correct value") {
                expect(subject.enqueuedFrontendManifest()).toNot(beNil())
            }
        }
        
        describe("-currentAvailable") {
            it("should return the correct value") {
                expect(subject.currentAvailable()) == false
            }
        }
        
        describe("-enqueuedAvailable") {
            it("should return the correct value") {
                expect(subject.enqueuedAvailable()) == true
            }
        }
        
        describe("-replaceWithEnqueued") {
            beforeEach {
                try! subject.replaceWithEnqueued()
            }
            it("should remove the current one") {
                expect(fileManager.removedAtPath) == subject.currentPath()
            }
            it("should copy the enqueued") {
                expect(fileManager.movedFrom) == subject.enqueuedPath()
                expect(fileManager.movedTo) == subject.currentPath()
            }
        }
        
        describe("-replaceWithZipped") {
            beforeEach {
                try! subject.replaceWithZipped()
            }
            it("should take the correct zip") {
                expect(zipExtractor.zipUrl) == NSURL(fileURLWithPath: subject.zipPath)
            }
            it("should extract into the correct directory") {
                expect(zipExtractor.destinationUrl) == NSURL(fileURLWithPath: subject.currentPath())
            }
            it("should extract it overwriting the existing content") {
                expect(zipExtractor.overwrite) == true
            }
        }
    }
}

// MARK: - Mocks

private class MockZipExtractor: ZipExtractor {
    
    var zipUrl: NSURL!
    var destinationUrl: NSURL!
    var overwrite: Bool!
    
    private override func unzipFile(zipFilePath: NSURL, destination: NSURL, overwrite: Bool, password: String?, progress: ((progress: Double) -> ())?) throws {
        self.zipUrl = zipFilePath
        self.destinationUrl = destination
        self.overwrite = overwrite
    }
}

private class MockFileManager: NSFileManager {
    var removedAtPath: String!
    var movedFrom: String!
    var movedTo: String!
    private override func removeItemAtPath(path: String) throws {
        self.removedAtPath = path
    }
    
    private override func moveItemAtPath(srcPath: String, toPath dstPath: String) throws {
        self.movedFrom = srcPath
        self.movedTo = dstPath
    }
}