//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherScripts
import FileModuleKit
import FileModuleMigrationKit

extension ComponentRegistry {

    func runMigrations() async throws {

        let scripts = ScriptExecutor(
            components: self,
            policy: .runAll
        )

        try await scripts.execute([
            File.Migrations.V1.self
        ])
    }
}
