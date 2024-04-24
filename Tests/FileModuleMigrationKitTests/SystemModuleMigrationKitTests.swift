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

        try await File.Permission.Query
            .insert(
                .init(
                    key: .init(rawValue: "foo.bar.baz"),
                    name: "foo"
                ),
                on: db
            )

        try await File.Variable.Query
            .insert(
                .init(
                    key: .init(rawValue: "foo"),
                    value: "foo"
                ),
                on: db
            )
    }
}
