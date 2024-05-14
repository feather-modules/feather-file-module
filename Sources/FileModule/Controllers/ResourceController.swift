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

struct ResourceController: FileResourceInterface,
    ControllerGet,
    ControllerList
{
    typealias Detail = File.Resource.Detail
    typealias List = File.Resource.List
    typealias Query = File.Resource.Query

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
            .sizeInBytes,
        ]

    func download(_ id: ID<File.Resource>, range: ClosedRange<UInt64>?)
        async throws -> ByteBuffer
    {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        try await Query.require(id.toKey(), on: db)

        return try await storage.download(
            key: id.toStorageFileKey(),
            range: range.map {
                .init(uncheckedBounds: (Int($0.lowerBound), Int($0.upperBound)))
            }
        )
    }

    func delete(_ id: ID<File.Resource>) async throws {
        try await bulkDelete(ids: [id])
    }

    func bulkDelete(ids: [ID<File.Resource>]) async throws {
        let db = try await components.database().connection()
        let storage = try await components.storage()

        for id in ids {
            try await Query.delete(id.toKey(), on: db)
            try await storage.delete(key: id.toStorageFileKey())
        }
    }
}
