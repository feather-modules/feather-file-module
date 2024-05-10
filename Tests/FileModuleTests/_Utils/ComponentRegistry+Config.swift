//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherDatabaseDriverSQLite
import FeatherStorageDriverLocal
import FeatherStorageDriverMemory
import Foundation
import Logging
import NIO
import SQLiteKit

extension ComponentRegistry {

    public func configure(
        _ threadPool: NIOThreadPool,
        _ eventLoopGroup: EventLoopGroup
    ) async throws {

        let connectionSource = SQLiteConnectionSource(
            configuration: .init(
                storage: .memory,
                enableForeignKeys: true
            ),
            threadPool: threadPool
        )

        let pool = EventLoopGroupConnectionPool(
            source: connectionSource,
            on: eventLoopGroup
        )

        try await addDatabase(
            SQLiteDatabaseComponentContext(
                pool: pool
            )
        )

        //try await addStorage(MemoryStorageComponentContext())

        let workUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
        try await addStorage(
            LocalStorageComponentContext(
                threadPool: threadPool,
                eventLoopGroup: eventLoopGroup,
                path: workUrl.absoluteString
            )
        )
    }
}
