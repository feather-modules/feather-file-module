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
    struct SimpleRandomNumberGenerator: RandomNumberGenerator {
        private var seed: UInt64

        init(seed: UInt64) {
            self.seed = seed
        }

        mutating func next() -> UInt64 {
            seed = (seed &* 1_664_525) &+ 1_013_904_223
            return seed
        }
    }

    let dummyBytes = (0...(1024 * 1024 * 5)).map { _ in "0" }.joined()
    //    let dummyBytes = ""
    let chunkLimit = 5

    func testSimpleUpload() async throws {
        var rng = SimpleRandomNumberGenerator(seed: 42)

        var stringData = ""
        for i in Array(1...100).shuffled(using: &rng) {
            stringData += "hello-world-\(i)"
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
        var rng = SimpleRandomNumberGenerator(seed: 42)

        let chunkedDetail = try await file.upload.startChunked()

        var orderedData: [(offset: Int, element: Int, data: String)] = []
        for i in Array(1...chunkLimit).shuffled(using: &rng).enumerated() {
            let s = "hello-world-\(i.element)" + dummyBytes

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

    func testChunkedUploadDouble() async throws {
        var rng = SimpleRandomNumberGenerator(seed: 42)

        let chunkedDetail = try await file.upload.startChunked()

        var orderedData: [(offset: Int, element: Int, data: String)] = []
        for i in Array(1...chunkLimit).shuffled(using: &rng).enumerated() {
            let firstChunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i.element,
                data: .init(
                    string: "first-hello-world-\(i.element)" + dummyBytes
                )
            )

            let s = "hello-world-\(i.element)" + dummyBytes

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i.element,
                data: .init(string: s)
            )

            XCTAssertEqual(chunkDetail.id, firstChunkDetail.id)

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
        var rng = SimpleRandomNumberGenerator(seed: 42)

        let chunkedDetail = try await file.upload.startChunked()

        for i in Array(1...(chunkLimit / 2)).shuffled(using: &rng) {
            let s = "hello-world-\(i)" + dummyBytes

            let chunkDetail = try await file.chunk.upload(
                uploadId: chunkedDetail.uploadId,
                number: i,
                data: .init(string: s)
            )

            XCTAssertEqual(chunkDetail.uploadId, chunkedDetail.uploadId)
            XCTAssertEqual(chunkDetail.number, i)
        }

        for i in Array(1...(chunkLimit / 2)).shuffled(using: &rng) {
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

        for i in Array((chunkLimit / 2) + 1...chunkLimit).shuffled(using: &rng)
        {
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
        var rng = SimpleRandomNumberGenerator(seed: 42)

        let chunkedDetail = try await file.upload.startChunked()

        var orderedData:
            [(offset: Int, element: Int, data: String, id: ID<File.Chunk>)] = []
        for i in Array(1...chunkLimit).shuffled(using: &rng).enumerated() {
            let s = "hello-world-\(i.element)" + dummyBytes

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

        let todeleteitems =
            Array(1...chunkLimit).shuffled(using: &rng)[
                0...chunkLimit / 2
            ]
        let removedElements = todeleteitems[0...(todeleteitems.count / 2)]
        let removedElementsById = todeleteitems[
            (todeleteitems.count / 2 + 1)...
        ]

        for removedElement in removedElements {
            try await file.chunk.delete(
                uploadId: chunkedDetail.uploadId,
                number: removedElement
            )
        }

        for removedElement in removedElementsById {
            try await file.chunk.delete(orderedData[removedElement - 1].id)
        }

        orderedData.removeAll { item in
            removedElements.contains(item.element)
                || removedElementsById.contains(item.element)
        }

        XCTAssertEqual(
            orderedData.count + removedElements.count
                + removedElementsById.count,
            chunkLimit
        )

        let chunkList = try await file.chunk.list(
            uploadId: chunkedDetail.uploadId,
            .init(sort: .init(by: .number, order: .asc), page: .init())
        )

        XCTAssertEqual(chunkList.items.count, orderedData.count)

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
