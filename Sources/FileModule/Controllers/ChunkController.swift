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
import NIOCore
import NanoID

struct ChunkController: FileChunkInterface,
    ControllerDelete,
    ControllerList
{
    typealias Detail = File.Chunk.Detail
    typealias List = File.Chunk.List
    typealias Query = File.Chunk.Query

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
            .key,
            .uploadKey,
            .number,
        ]

    func list(
        uploadId: ID<File.Upload>,
        _ input: File.Chunk.List.Query
    ) async throws -> File.Chunk.List {
        let db = try await components.database().connection()
        try await File.Upload.Query.require(uploadId.toKey(), on: db)

        return try await list(
            input,
            filters: [
                .init(columns: [
                    .init(
                        column: .uploadKey,
                        operator: .equal,
                        value: uploadId
                    )
                ])
            ]
        )
    }

    func upload(
        uploadId: ID<File.Upload>,
        number: Int,
        data: ByteBuffer
    ) async throws -> File.Chunk.Detail {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        let uploadModel = try await File.Upload.Query.require(
            uploadId.toKey(),
            on: db
        )

        let chunk = try await storage.upload(
            multipartId: uploadModel.storageKey,
            key: uploadModel.resourceKey.toStorageFileKey(),
            number: number,
            buffer: data
        )

        let ret: Model

        if let chunkModel = try await Query.getFirst(
            filter: .init(groups: [
                .init(columns: [
                    .init(
                        column: .uploadKey,
                        operator: .equal,
                        value: uploadId
                    ),
                    .init(column: .number, operator: .equal, value: number),
                ])
            ]),
            on: db
        ) {
            ret = Model(
                key: chunkModel.key,
                uploadKey: chunkModel.uploadKey,
                number: chunkModel.number,
                storageKey: chunk.chunkId
            )
            // actually this is unnecessary but it could be useful
            //  for the future when it comes to time stamp or whatever and
            //  it handles when storageKey change time to time (doesn't happen in s3)
            try await Query.update(chunkModel.key, ret, on: db)
        }
        else {
            ret = Model(
                key: NanoID.generateKey(),
                uploadKey: uploadId.toKey(),
                number: chunk.number,
                storageKey: chunk.chunkId
            )
            try await Query.insert(ret, on: db)
        }

        return try .init(model: ret)
    }

    func require(uploadId: ID<File.Upload>, number: Int) async throws
        -> File.Chunk.Detail
    {
        let db = try await components.database().connection()

        let chunk = try await Query.getFirst(
            filter: .init(groups: [
                .init(columns: [
                    .init(
                        column: .uploadKey,
                        operator: .equal,
                        value: uploadId
                    ),
                    .init(column: .number, operator: .equal, value: number),
                ])
            ]),
            on: db
        )

        guard let chunk else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: Model.self),
                keyName: Model.keyName.rawValue
            )
        }

        return try .init(model: chunk)
    }

    func delete(_ id: ID<File.Chunk>) async throws {
        try await bulkDelete(ids: [id])
    }

    func bulkDelete(uploadId: ID<File.Upload>, numbers: [Int]) async throws {
        let db = try await components.database().connection()

        try await Query.delete(
            filter: .init(groups: [
                .init(columns: [
                    .init(
                        column: .uploadKey,
                        operator: .equal,
                        value: uploadId
                    ),
                    .init(column: .number, operator: .in, value: numbers),
                ])
            ]),
            on: db
        )
    }

    func delete(uploadId: ID<File.Upload>, number: Int) async throws {
        try await bulkDelete(uploadId: uploadId, numbers: [number])
    }
}
