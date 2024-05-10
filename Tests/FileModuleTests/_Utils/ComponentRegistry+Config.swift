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
import FeatherStorageDriverS3
import Foundation
import Logging
import NIO
import SQLiteKit
import SotoCore

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

        //memory test
        //        try await addStorage(MemoryStorageComponentContext())

        //        //local test
        let workUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
        try await addStorage(
            LocalStorageComponentContext(
                threadPool: threadPool,
                eventLoopGroup: eventLoopGroup,
                path: workUrl.absoluteString
            )
        )

        //s3 test
        //        let id = ProcessInfo.processInfo.environment["S3_ID"]!
        //        let secret = ProcessInfo.processInfo.environment["S3_SECRET"]!
        //        let region = ProcessInfo.processInfo.environment["S3_REGION"]!
        //        let bucket = ProcessInfo.processInfo.environment["S3_BUCKET"]!
        //
        //        let client = AWSClient(
        //            credentialProvider: .static(
        //                accessKeyId: id,
        //                secretAccessKey: secret
        //            ),
        //            httpClientProvider: .createNewWithEventLoopGroup(eventLoopGroup)
        //        )
        //
        //        try await addStorage(
        //            S3StorageComponentContext(
        //                eventLoopGroup: eventLoopGroup,
        //                client: client,
        //                region: .init(rawValue: region),
        //                bucket: .init(name: bucket),
        //                timeout: .seconds(60)
        //            )
        //        )
    }
}
