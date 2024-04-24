//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit

public protocol FileStorageInterface: Sendable {

    func list(
        _ input: File.Storage.List.Query
    ) async throws -> File.Storage.List

    func reference(
        ids: [ID<File.Storage>]
    ) async throws -> [File.Storage.Reference]

    func create(
        _ input: File.Storage.Create
    ) async throws -> File.Storage.Detail

    func get(
        _ id: ID<File.Storage>
    ) async throws -> File.Storage.Detail

    func update(
        _ id: ID<File.Storage>,
        _ input: File.Storage.Update
    ) async throws -> File.Storage.Detail

    func patch(
        _ id: ID<File.Storage>,
        _ input: File.Storage.Patch
    ) async throws -> File.Storage.Detail

    func bulkDelete(
        ids: [ID<File.Storage>]
    ) async throws

}
