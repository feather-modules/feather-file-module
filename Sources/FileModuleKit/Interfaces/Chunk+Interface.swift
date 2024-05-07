//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit

public protocol FileChunkInterface: Sendable {

    func list(
        _ input: File.Chunk.List.Query
    ) async throws -> File.Chunk.List

    func require(
        _ id: ID<File.Chunk>
    ) async throws -> File.Chunk.Detail

    func bulkDelete(
        ids: [ID<File.Chunk>]
    ) async throws

}
