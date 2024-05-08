//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/03/2024.
//

import FeatherDatabase
import FileModuleDatabaseKit
import FileModuleKit
import XCTest

@testable import FileModuleMigrationKit

final class FileModuleMigrationKitTests: TestCase {

    func testSeedMigration() async throws {
        try await scripts.execute([
            File.Migrations.V1.self
        ])

        let db = try await components.database().connection()

        try await File.Resource.Query
            .insert(
                .init(
                    key: .init(rawValue: "foo.bar.baz"),
                    sizeInBytes: 42
                ),
                on: db
            )

        try await File.Upload.Query
            .insert(
                .init(
                    key: .init(rawValue: "foo"),
                    resourceKey: .init(rawValue: "foo")
                ),
                on: db
            )

        try await File.Chunk.Query
            .insert(
                .init(
                    key: .init(rawValue: "foo"),
                    uploadKey: .init(rawValue: "foo"),
                    number: 42
                ),
                on: db
            )

    }
}
