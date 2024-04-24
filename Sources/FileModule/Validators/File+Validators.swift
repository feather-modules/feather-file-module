//
//  File.swift
//
//
//  Created by Tibor Bodecs on 15/02/2024.
//

import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FileModuleDatabaseKit
import FileModuleKit

extension File.Storage {

    enum Validators {

        static func uniqueKey(
            _ value: ID<File.Storage>,
            on db: Database,
            _ originalKey: ID<File.Storage>? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: .key,
                        originalValue: originalKey,
                        on: db
                    )
                ]
            )
        }

        static func key(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .nonempty(),
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }

        static func value(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "value",
                value: value,
                rules: [
                    .nonempty()
                ]
            )
        }
    }
}

extension File.Storage.Create {

    public func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            File.Storage.Validators.key(key.rawValue)
            File.Storage.Validators.uniqueKey(key, on: db)
            File.Storage.Validators.value(value)
        }
        try await v.validate()
    }
}

extension File.Storage.Update {

    public func validate(
        _ originalKey: ID<File.Storage>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            File.Storage.Validators.key(key.rawValue)
            File.Storage.Validators.uniqueKey(
                key,
                on: db,
                originalKey
            )
            File.Storage.Validators.value(value)
        }
        try await v.validate()
    }
}

extension File.Storage.Patch {

    public func validate(
        _ originalKey: ID<File.Storage>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let key {
                File.Storage.Validators.key(key.rawValue)
                File.Storage.Validators.uniqueKey(
                    key,
                    on: db,
                    originalKey
                )
            }
            if let value {
                File.Storage.Validators.value(value)
            }
        }
        try await v.validate()
    }
}
