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
    static func shuffleArray<T>(_ array: [T], seed: Int) -> [T] {
        var ret = array
        srand48(seed)
        for i in 0..<(array.count - 1) {
            let j = Int(drand48() * Double(array.count - i)) + i
            ret.swapAt(i, j)
        }
        return ret
    }

    func testSimpleUpload() async throws {
        var stringData = ""
        for i in Self.shuffleArray(Array(0...100), seed: 42) {
            stringData += "hello-world-\(i)"
            print(i)
        }

        let simpleDetail = try await file.upload.simpleUpload(
            .init(string: stringData)
        )

        XCTAssertFalse(simpleDetail.resourceId.rawValue.isEmpty)

        let resourceList = try await file.resource.list(
            .init(sort: .init(by: .id, order: .asc), page: .init())
        )

        XCTAssertEqual(resourceList.count, 1)

        let resourceDetail = try await file.resource.require(
            simpleDetail.resourceId
        )

        XCTAssertEqual(resourceDetail.id, resourceList.items[0].id)
        XCTAssertEqual(
            resourceDetail.sizeInBytes,
            resourceList.items[0].sizeInBytes
        )

        let data = try await file.resource.download(
            simpleDetail.resourceId,
            range: nil
        )

        XCTAssertEqual(data.readableBytes, Int(resourceDetail.sizeInBytes))
        XCTAssertEqual(String(buffer: data), stringData)

        try await file.resource.delete(resourceDetail.id)

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
        let chunkedDetail = try await file.upload.startChunked()

        var orderedData: [(offset: Int, element: Int, data: String)] = []
        for i in Self.shuffleArray(Array(0...100), seed: 42).enumerated() {
            let s = "hello-world-\(i.element)"

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i.element,
                data: .init(string: s)
            )

            orderedData += [(i.offset, i.element, s)]
            orderedData.sort { lhs, rhs in
                lhs.element < rhs.element
            }

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i.element)

            let chunkList = try await file.chunk.list(
                uploadId: chunkDetail.uploadId,
                .init(sort: .init(by: .number, order: .asc), page: .init())
            )

            XCTAssertEqual(chunkList.count, UInt(i.offset + 1))

            for item in chunkList.items.enumerated() {
                XCTAssertEqual(
                    item.element.number,
                    orderedData[item.offset].element
                )
                XCTAssertEqual(item.element.uploadId, chunkedDetail.uploadId)
            }
        }

        let finishDetail = try await file.upload.finishChunked(
            chunkedDetail.uploadId
        )

        XCTAssertFalse(finishDetail.resourceId.rawValue.isEmpty)

        let resourceList = try await file.resource.list(
            .init(sort: .init(by: .id, order: .asc), page: .init())
        )

        XCTAssertEqual(resourceList.count, 1)

        let resourceDetail = try await file.resource.require(
            finishDetail.resourceId
        )

        XCTAssertEqual(resourceDetail.id, resourceList.items[0].id)
        XCTAssertEqual(
            resourceDetail.sizeInBytes,
            resourceList.items[0].sizeInBytes
        )

        let data = try await file.resource.download(
            finishDetail.resourceId,
            range: nil
        )

        XCTAssertEqual(data.readableBytes, Int(resourceDetail.sizeInBytes))
        XCTAssertEqual(
            String(buffer: data),
            orderedData.map { $0.data }.joined()
        )

        try await file.resource.delete(resourceDetail.id)

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
        let chunkedDetail = try await file.upload.startChunked()

        for i in Self.shuffleArray(Array(0...50), seed: 42) {
            let s = "hello-world-\(i)"

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i,
                data: .init(string: s)
            )

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i)
        }

        for i in Self.shuffleArray(Array(0...50), seed: 42) {
            let chunkDetail = try await file.chunk.require(
                uploadId: chunkedDetail.uploadId,
                number: i
            )

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i)

            let chunkDetailById = try await file.chunk.require(chunkDetail.id)

            XCTAssertEqual(chunkDetail, chunkDetailById)
        }

        try await file.upload.abortChunked(
            chunkedDetail.uploadId
        )

        for i in Self.shuffleArray(Array(51...100), seed: 42) {
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

    func testChunkedUploadChunkDelete() async throws {
        let chunkedDetail = try await file.upload.startChunked()

        var orderedData:
            [(offset: Int, element: Int, data: String, id: ID<File.Chunk>)] = []
        for i in Self.shuffleArray(Array(0...100), seed: 42).enumerated() {
            let s = "hello-world-\(i.element)"

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i.element,
                data: .init(string: s)
            )

            orderedData += [(i.offset, i.element, s, chunkDetail.id)]
            orderedData.sort { lhs, rhs in
                lhs.element < rhs.element
            }

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i.element)

            let chunkList = try await file.chunk.list(
                uploadId: chunkDetail.uploadId,
                .init(sort: .init(by: .number, order: .asc), page: .init())
            )

            XCTAssertEqual(chunkList.count, UInt(i.offset + 1))

            for item in chunkList.items.enumerated() {
                XCTAssertEqual(
                    item.element.number,
                    orderedData[item.offset].element
                )
                XCTAssertEqual(item.element.uploadId, chunkedDetail.uploadId)
            }
        }

        let removedElements = [0, 42, 56, 67, 12, 100]
        let removedElementsById = [74, 32, 44, 11]

        for removedElement in removedElements {
            try await file.chunk.delete(
                uploadId: chunkedDetail.uploadId,
                number: removedElement
            )
        }

        for removedElement in removedElementsById {
            try await file.chunk.delete(orderedData[removedElement].id)
        }

        orderedData.removeAll { item in
            removedElements.contains(item.element)
                || removedElementsById.contains(item.element)
        }

        XCTAssertEqual(
            orderedData.count + removedElements.count
                + removedElementsById.count,
            101
        )

        let finishDetail = try await file.upload.finishChunked(
            chunkedDetail.uploadId
        )

        XCTAssertFalse(finishDetail.resourceId.rawValue.isEmpty)

        let resourceList = try await file.resource.list(
            .init(sort: .init(by: .id, order: .asc), page: .init())
        )

        XCTAssertEqual(resourceList.count, 1)

        let resourceDetail = try await file.resource.require(
            finishDetail.resourceId
        )

        XCTAssertEqual(resourceDetail.id, resourceList.items[0].id)
        XCTAssertEqual(
            resourceDetail.sizeInBytes,
            resourceList.items[0].sizeInBytes
        )

        let data = try await file.resource.download(
            finishDetail.resourceId,
            range: nil
        )

        XCTAssertEqual(data.readableBytes, Int(resourceDetail.sizeInBytes))
        XCTAssertEqual(
            String(buffer: data),
            orderedData.map { $0.data }.joined()
        )

        try await file.resource.delete(resourceDetail.id)

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
}
