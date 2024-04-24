//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherDatabaseDriverSQLite
import FeatherScripts
import Logging
import NIO
import SQLiteKit
import XCTest

class TestCase: XCTestCase {

    var eventLoopGroup: EventLoopGroup!
    var components: ComponentRegistry!
    var scripts: ScriptExecutor!

    override func setUp() async throws {
        self.components = ComponentRegistry()
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let threadPool = NIOThreadPool(numberOfThreads: 1)
        threadPool.start()

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

        try await components.addDatabase(
            SQLiteDatabaseComponentContext(
                pool: pool
            )
        )

        self.scripts = ScriptExecutor(
            components: components,
            policy: .runAll
        )
    }

    override func tearDown() async throws {
        try await eventLoopGroup.shutdownGracefully()
    }
}
