//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherStorage
import FileModuleDatabaseKit
import FileModuleKit
import Logging
import NanoID

struct UploadController: FileUploadInterface,
    ControllerGet,
    ControllerList
{
    typealias Detail = File.Upload.ChunkedDetail
    typealias List = File.Upload.List
    typealias Query = File.Upload.Query

    let components: ComponentRegistry
    let file: FileModuleInterface

    public init(
        components: ComponentRegistry,
        file: FileModuleInterface
    ) {
        self.components = components
        self.file = file
    }

    // MARK: -

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .key
        ]

    func startChunked() async throws -> File.Upload.ChunkedDetail {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        let newResourceKey: Key<File.Resource> = NanoID.generateKey()

        try await storage.create(
            key: newResourceKey.toStorageFolderKey()
        )
        let uploadId = try await storage.createMultipartId(
            key: newResourceKey.toStorageFileKey()
        )

        let newModel = Model.init(
            key2: NanoID.generateKey(),
            resourceKey: newResourceKey,
            storageKey: uploadId
        )

        try await File.Upload.Query.insert(newModel, on: db)

        return try .init(model: newModel)
    }

    func finishChunked(_ id: ID<File.Upload>) async throws
        -> File.Upload.FinishChunkedDetail
    {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        let chunkedModel = try await Query.require(id.toKey(), on: db)
        let chunkList = try await File.Chunk.Query.listAll(
            filter: .init(column: .uploadKey, operator: .equal, value: id),
            on: db
        )

        try await Query.delete(id.toKey(), on: db)
        try await File.Chunk.Query.delete(
            filter: .init(column: .uploadKey, operator: .equal, value: id),
            on: db
        )

        try await storage.finish(
            multipartId: chunkedModel.storageKey,
            key: chunkedModel.resourceKey.toStorageFileKey(),
            chunks: chunkList.map {
                .init(chunkId: $0.storageKey, number: $0.number)
            }
        )

        try await File.Resource.Query.insert(
            .init(
                key: chunkedModel.resourceKey,
                sizeInBytes: storage.size(
                    key: chunkedModel.resourceKey.toStorageFileKey()
                )
            ),
            on: db
        )

        return try .init(model: chunkedModel)
    }

    func abortChunked(_ id: ID<File.Upload>) async throws {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        let chunkedModel = try await Query.require(id.toKey(), on: db)

        try await Query.delete(id.toKey(), on: db)
        try await File.Chunk.Query.delete(
            filter: .init(column: .uploadKey, operator: .equal, value: id),
            on: db
        )

        try await storage.abort(
            multipartId: chunkedModel.storageKey,
            key: chunkedModel.resourceKey.toStorageFileKey()
        )
    }

    func simpleUpload(_ data: File.BinaryData) async throws
        -> File.Upload.SimpleDetail
    {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        let newResourceKey: Key<File.Resource> = NanoID.generateKey()

        try await storage.upload(
            key: newResourceKey.toStorageFileKey(),
            buffer: data
        )

        let resourceModel: File.Resource.Model = .init(
            key: newResourceKey,
            sizeInBytes: await storage.size(
                key: newResourceKey.toStorageFileKey()
            )
        )

        try await File.Resource.Query.insert(resourceModel, on: db)

        return try .init(model: resourceModel)
    }
}
