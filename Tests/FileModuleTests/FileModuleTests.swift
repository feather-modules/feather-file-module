//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import FeatherModuleKit
import FileModuleKit
import XCTest

final class FileModuleTests: TestCase {
    func testSimpleUpload() async throws {
        var stringData = ""
        for i in 0...100 {
            stringData += "hello-world-\(i)"
        }

        let simpleDetail = try await file.upload.simpleUpload(
            .init(string: stringData)
        )

        XCTAssertFalse(simpleDetail.resourceId.rawValue.isEmpty)

        let resourceDetail = try await file.resource.require(
            simpleDetail.resourceId
        )

        let data = try await file.resource.download(
            simpleDetail.resourceId,
            range: nil
        )

        XCTAssertEqual(data.readableBytes, Int(resourceDetail.sizeInBytes))
        XCTAssertEqual(String(buffer: data), stringData)

        try await file.resource.remove(resourceDetail.id)

        do {
            let _ = try await file.resource.require(
                resourceDetail.id
            )

            XCTFail()
        }
        catch ModuleError.objectNotFound(let module, let keyName) {
            XCTAssertTrue(module.contains("File.Resource"))
            XCTAssertEqual(keyName, "key")
        }
    }

    func testChunkedUpload() async throws {
        let chunkedDetail = try await file.upload.createChunked()

        var stringData = ""
        for i in 0...100 {
            let s = "hello-world-\(i)"

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i,
                data: .init(string: s)
            )

            stringData += s

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i)
        }

        let finishDetail = try await file.upload.finishChunked(
            chunkedDetail.uploadId
        )

        let resourceDetail = try await file.resource.require(
            finishDetail.resourceId
        )

        let data = try await file.resource.download(
            finishDetail.resourceId,
            range: nil
        )

        XCTAssertEqual(data.readableBytes, Int(resourceDetail.sizeInBytes))
        XCTAssertEqual(String(buffer: data), stringData)

        try await file.resource.remove(resourceDetail.id)

        do {
            let _ = try await file.resource.require(
                resourceDetail.id
            )

            XCTFail()
        }
        catch ModuleError.objectNotFound(let module, let keyName) {
            XCTAssertTrue(module.contains("File.Resource"))
            XCTAssertEqual(keyName, "key")
        }
    }

    func testChunkedUploadAbort() async throws {
        let chunkedDetail = try await file.upload.createChunked()

        for i in 0...50 {
            let s = "hello-world-\(i)"

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i,
                data: .init(string: s)
            )

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i)
        }

        try await file.upload.abortChunked(
            chunkedDetail.uploadId
        )

        for i in 51...100 {
            let s = "hello-world-\(i)"

            do {
                let _ = try await file.chunk.upload(
                    uploadId: chunkedDetail.uploadId,
                    number: i,
                    data: .init(string: s)
                )

                XCTFail()
            }
            catch ModuleError.objectNotFound(let module, let keyName) {
                XCTAssertTrue(module.contains("File.Upload"))
                XCTAssertEqual(keyName, "key")
            }
        }
    }
}
